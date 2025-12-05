class Like < ApplicationRecord
  belongs_to :review, counter_cache: true
  belongs_to :user
  validates_uniqueness_of :review_id, scope: :user_id
end
