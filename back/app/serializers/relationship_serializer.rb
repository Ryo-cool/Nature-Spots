class RelationshipSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      user_id: object.user_id,
      follow_id: object.follow_id,
      created_at: object.created_at
    }
  end

  def with_follow_user
    as_json.merge(
      follow: UserSerializer.new(object.follow).as_json
    )
  end

  def with_user
    as_json.merge(
      user: UserSerializer.new(object.user).as_json
    )
  end
end
