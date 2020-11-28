class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :spot
  validates_uniqueness_of :spot_id, scope: :user_id
end
