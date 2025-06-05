class Review < ApplicationRecord
  
  belongs_to :spot, counter_cache: true
  belongs_to :user
  has_many :likes, dependent: :destroy, counter_cache: true
  has_many :liked_users, through: :likes, source: :user

  mount_uploader :image, ImageUploader

  # バリデーション
  validates :title, presence: true,
                   length: { minimum: 2, maximum: 100 },
                   format: { with: /\A[ぁ-んァ-ヶー一-龠\s]+\z/, message: "は日本語で入力してください" }

  validates :text, presence: true,
                     length: { minimum: 10, maximum: 2000 }

  validates :rating, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  validates :image, file_size: { less_than: 5.megabytes, message: "は5MB以下にしてください" },
                   file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'], message: "はJPEG、PNG、GIF形式のみアップロード可能です" }

  # スコープ
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(likes_count: :desc) }

  # Use counter cache column instead of database count
  def like_count
    likes_count
  end

  # いいね済みかどうか
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
