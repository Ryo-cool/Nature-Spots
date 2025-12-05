class Relationship < ApplicationRecord

  belongs_to :user, counter_cache: :followings_count
  belongs_to :follow, class_name: 'User', counter_cache: :followers_count

  validates :user_id, presence: true
  validates :follow_id, presence: true
  validates :user_id, uniqueness: { scope: :follow_id }
  
  validate :cannot_follow_self

  private

  def cannot_follow_self
    errors.add(:follow_id, "自分自身をフォローすることはできません") if user_id == follow_id
  end
  
end
