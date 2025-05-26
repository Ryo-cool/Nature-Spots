class PrefectureLocationService < ApplicationService
  def call
    data = {
      prefectures: fetch_prefectures,
      locations: fetch_locations
    }
    
    success(data)
  rescue StandardError => e
    failure(["都道府県・地域データの取得に失敗しました: #{e.message}"])
  end

  private

  def fetch_prefectures
    Rails.cache.fetch("all_prefectures", expires_in: 24.hours) do
      Prefecture.all.to_a
    end
  end

  def fetch_locations
    Rails.cache.fetch("all_locations", expires_in: 24.hours) do
      Location.all.to_a
    end
  end
end 