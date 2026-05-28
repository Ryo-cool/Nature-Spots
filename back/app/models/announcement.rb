class Announcement < ApplicationRecord
  belongs_to :author, class_name: "User"
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true, length: { maximum: 2000 }

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }

  def published?
    published_at.present?
  end
end
