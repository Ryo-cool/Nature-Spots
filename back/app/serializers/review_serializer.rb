class ReviewSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      title: object.title,
      content: object.content,
      rating: object.rating,
      created_at: object.created_at,
      updated_at: object.updated_at
    }
  end

  def with_user
    as_json.merge(
      user: UserSerializer.new(object.user).as_json
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