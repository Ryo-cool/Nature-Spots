class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :notifiable, polymorphic: true, optional: true

  # 通知種別
  enum :action, { review_posted: 0, followed: 1, announcement: 2 }

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  # 未読の場合のみ既読にする
  def mark_as_read!
    update!(read_at: Time.current) if read_at.nil?
  end

  def read?
    read_at.present?
  end
end
