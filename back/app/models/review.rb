class Review < ApplicationRecord
  belongs_to :spot
  belongs_to :user
  has_many :likes
  has_many :liked_users, through: :likes, source: :user

  mount_uploader :image, ImageUploader
end
