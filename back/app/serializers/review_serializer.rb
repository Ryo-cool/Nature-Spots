class ReviewSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      title: object.title,
      text: object.text,
      rating: object.rating,
      wentday: object.wentday,
      image: serialize_uploader(object.image),
      created_at: object.created_at,
      updated_at: object.updated_at
    }
  end

  def with_user
    as_json.merge(
      user: UserSerializer.new(object.user).as_json,
      likes: object.likes.map { |like| LikeSerializer.new(like).as_json }
    )
  end

  def with_spot
    as_json.merge(
      spot: SpotSerializer.new(object.spot).as_json
    )
  end

  def with_associations
    as_json.merge(
      user: UserSerializer.new(object.user).as_json,
      spot: SpotSerializer.new(object.spot).as_json
    )
  end
end 