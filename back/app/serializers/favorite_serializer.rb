class FavoriteSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      user_id: object.user_id,
      spot_id: object.spot_id,
      created_at: object.created_at
    }
  end

  def with_spot
    as_json.merge(
      spot: SpotSerializer.new(object.spot).as_json
    )
  end

  def with_user
    as_json.merge(
      user: UserSerializer.new(object.user).as_json
    )
  end
end
