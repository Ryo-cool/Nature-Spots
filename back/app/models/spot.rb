class Spot < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :location
  mount_uploader :photo, ImageUploader
  has_many :reviews, dependent: :destroy
  belongs_to :user
  has_many :favorites, dependent: :destroy

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

  validates :description, length: { maximum: 1000 }

  # スコープ
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(review_count: :desc) }
  
  def review_count
    reviews.count
  end

  def average_rating
    reviews.average(:rating)&.round(1) || 0
  end
end
