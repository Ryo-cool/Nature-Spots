# app/validators/file_content_type_validator.rb
class FileContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # This is a dummy validator to allow specs to run.
    # Replace with actual validation logic if needed.
    # Options like options[:allow] (e.g., ['image/jpeg', 'image/png']) can be accessed here.
    # For example, to simulate a pass:
    # return true

    # To simulate an error:
    # if value.present? && !options[:allow].include?(value.content_type)
    #   record.errors.add(attribute, options[:message] || "has an invalid content type")
    # end
  end
end
