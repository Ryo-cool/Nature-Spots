class ApplicationSerializer
  include ActiveModel::Serialization

  def initialize(object, options = {})
    @object = object
    @options = options
  end

  private

  attr_reader :object, :options
end 