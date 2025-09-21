class UserSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      name: object.name,
      email: object.email,
      image: serialize_uploader(object.image),
      introduction: object.introduction,
      created_at: object.created_at
    }
  end

  def with_associations
    as_json.merge(
      reviews_count: object.reviews.count,
      favorites_count: object.favorites.count,
      followings_count: object.followings.count,
      followers_count: object.followers.count
    )
  end

  def with_detailed_data
    {
      user: as_json,
      reviews: object.reviews.includes(:spot).map { |review| ReviewSerializer.new(review).with_spot },
      favorites: object.favorite_spots.includes(:prefecture, :location).map { |spot| SpotSerializer.new(spot).as_json },
      followings: object.followings.map { |user| UserSerializer.new(user).as_json },
      followers: object.followers.map { |user| UserSerializer.new(user).as_json }
    }
  end
end 