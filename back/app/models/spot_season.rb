class SpotSeason < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :spot
  belongs_to_active_hash :season

  validates :season_id, presence: true,
                        inclusion: { in: ->(_record) { Season.all.map(&:id) } }
  validates :spot_id, uniqueness: { scope: :season_id }
end
