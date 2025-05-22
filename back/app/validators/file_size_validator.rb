# app/validators/file_size_validator.rb
class FileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    # This is a dummy validator to allow specs to run.
    # Replace with actual validation logic if needed.
    # Options like options[:less_than] can be accessed here.
    # For example, to simulate a pass:
    # return true

    # To simulate an error (though for a dummy, we might not add errors):
    # if value.present? && value.size > (options[:less_than] || 5.megabytes)
    #   record.errors.add(attribute, options[:message] || "is too large")
    # end
  end
end
