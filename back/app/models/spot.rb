class Spot < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :location
  mount_uploader :photo, ImageUploader
  has_many :reviews
  belongs_to :user, optional: true
  has_many :favorites, dependent: :destroy

  validates :name,presence: true
  validates :photo,presence: true
  
  def review_count
    reviews.count
  end
end
