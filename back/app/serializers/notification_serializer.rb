class NotificationSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      action: object.action,
      read: object.read_at.present?,
      created_at: object.created_at,
      actor: object.actor && UserSerializer.new(object.actor).as_json,
      notifiable: serialize_notifiable
    }
  end

  private

  def serialize_notifiable
    case object.notifiable
    when Review
      {
        type: "review",
        id: object.notifiable.id,
        spot_id: object.notifiable.spot_id,
        title: object.notifiable.title
      }
    when Relationship
      {
        type: "relationship",
        user_id: object.notifiable.user_id
      }
    when Announcement
      {
        type: "announcement",
        id: object.notifiable.id,
        title: object.notifiable.title,
        body: object.notifiable.body
      }
    end
  end
end
