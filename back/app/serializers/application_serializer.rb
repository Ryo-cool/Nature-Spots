class ApplicationSerializer
  include ActiveModel::Serialization

  def initialize(object, options = {})
    @object = object
    @options = options
  end

  private

  attr_reader :object, :options

  def serialize_uploader(uploader)
    return { url: nil } if uploader.nil?

    url = uploader.respond_to?(:url) ? uploader.url : nil

    { url: url }
  end

  def serialize_active_hash(resource)
    return nil if resource.blank?

    {
      id: resource.id,
      type: resource.class.name.demodulize.underscore,
      attributes: {
        name: resource.name
      }
    }
  end
end
