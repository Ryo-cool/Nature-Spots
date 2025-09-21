class LikeSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      user_id: object.user_id,
      created_at: object.created_at,
      updated_at: object.updated_at
    }
  end
end
