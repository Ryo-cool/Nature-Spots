class SpotSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      name: object.name,
      introduction: object.introduction,
      photo: serialize_uploader(object.photo),
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
    # Assume associations are already loaded via includes in controller
    review_count = object.reviews.size

    as_json.merge(
      user: object.user ? UserSerializer.new(object.user).as_json : nil,
      reviews: object.reviews.map { |review| ReviewSerializer.new(review).with_user },
      favorite_users: object.favorites.map { |fav| UserSerializer.new(fav.user).as_json },
      favorite_user_ids: object.favorites.map(&:user_id),
      review_count: review_count,
      reviews_count: review_count,
      average_rating: calculate_average_rating,
      prefecture_resource: prefecture_resource,
      location_resource: location_resource
    )
  end

  def prefecture_resource
    serialize_active_hash(object.prefecture)
  end

  def location_resource
    serialize_active_hash(object.location)
  end

  def with_ranking_data
    as_json.merge(
      review_count: object.review_count,
      average_rating: object.average_rating
    )
  end

  private

  def calculate_average_rating
    return 0 if object.reviews.empty?
    (object.reviews.sum(&:rating).to_f / object.reviews.size).round(1)
  end
end
