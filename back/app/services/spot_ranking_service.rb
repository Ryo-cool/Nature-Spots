class SpotRankingService < ApplicationService
  def initialize(limit: 5)
    @limit = limit
  end

  def call
    spots = fetch_ranking_spots
    serialized_spots = spots.map { |spot| SpotSerializer.new(spot).with_ranking_data }
    
    success(spots: serialized_spots)
  rescue StandardError => e
    failure(["ランキングの取得に失敗しました: #{e.message}"])
  end

  private

  attr_reader :limit

  def fetch_ranking_spots
    Rails.cache.fetch("spot_ranking_#{limit}", expires_in: 1.hour) do
      Spot.joins(:reviews)
          .includes(:prefecture, :location)
          .group('spots.id')
          .order('COUNT(reviews.id) DESC')
          .limit(limit)
          .to_a
    end
  end
end 