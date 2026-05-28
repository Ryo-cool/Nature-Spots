class AnnouncementSerializer < ApplicationSerializer
  def as_json(options = {})
    {
      id: object.id,
      title: object.title,
      body: object.body,
      published_at: object.published_at,
      created_at: object.created_at
    }
  end

  def with_author
    as_json.merge(
      author: UserSerializer.new(object.author).as_json
    )
  end
end
