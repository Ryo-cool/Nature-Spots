class SpotSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      name: object.name,
      introduction: object.introduction,
      photo: object.photo&.url,
      address: object.address,
      longitude: object.longitude,
      latitude: object.latitude,
      prefecture: object.prefecture&.name,
      prefecture_id: object.prefecture_id,
      location: object.location&.name,
      location_id: object.location_id,
      created_at: object.created_at,
      updated_at: object.updated_at
    }
  end

  def with_details
    as_json.merge(
      user: object.user ? UserSerializer.new(object.user).as_json : nil,
      reviews: object.reviews.includes(:user).map { |review| ReviewSerializer.new(review).with_user },
      favorite_users: object.favorites.includes(:user).map { |fav| UserSerializer.new(fav.user).as_json },
      review_count: object.review_count,
      average_rating: object.average_rating
    )
  end

  def with_ranking_data
    as_json.merge(
      review_count: object.review_count,
      average_rating: object.average_rating
    )
  end
end 