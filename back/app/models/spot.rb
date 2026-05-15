class Spot < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :location
  mount_uploader :photo, ImageUploader
  has_many :reviews, dependent: :destroy, counter_cache: true
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :spot_seasons, dependent: :destroy

  # バリデーション
  validates :name, presence: true,
                  length: { minimum: 2, maximum: 100 },
                  japanese_text: true

  validates :photo, presence: true,
                   file_size: { less_than: 5.megabytes },
                   file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }

  validates :prefecture_id, presence: true
  validates :location_id, presence: true

  validates :address, presence: true,
                     length: { maximum: 255 }

  validates :introduction, length: { maximum: 1000 }

  # スコープ
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(reviews_count: :desc) }
  scope :in_season, ->(season_id) {
    joins(:spot_seasons).where(spot_seasons: { season_id: season_id }).distinct
  }

  # Use counter cache column instead of database count
  def review_count
    reviews_count
  end

  def average_rating
    return 0 if reviews_count == 0
    reviews.average(:rating)&.round(1) || 0
  end

  # ActiveHash::Associations は has_many :through 経由の ActiveHash アクセスを
  # 直接サポートしないため、season_ids から Season を引き直す
  def seasons
    Season.where(id: spot_seasons.map(&:season_id))
  end

  def season_ids=(ids)
    season_id_set = Array(ids).reject(&:blank?).map(&:to_i).uniq
    existing = spot_seasons.map(&:season_id)
    (existing - season_id_set).each do |sid|
      spot_seasons.where(season_id: sid).destroy_all
    end
    (season_id_set - existing).each do |sid|
      spot_seasons.build(season_id: sid)
    end
  end
end
