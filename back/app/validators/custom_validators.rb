class FileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?
    
    max_size = options[:less_than] || 5.megabytes
    
    if value.respond_to?(:size) && value.size > max_size
      record.errors.add(attribute, options[:message] || "は#{max_size / 1.megabyte}MB以下にしてください")
    end
  end
end

class FileContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?
    
    allowed_types = options[:allow] || []
    
    if value.respond_to?(:content_type) && !allowed_types.include?(value.content_type)
      record.errors.add(attribute, options[:message] || "は許可されていないファイル形式です")
    end
  end
end

class JapaneseTextValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?
    
    # 日本語文字（ひらがな、カタカナ、漢字）、数字、アルファベット、スペースを許可
    unless value.match?(/\A[ぁ-んァ-ヶー一-龠a-zA-Z0-9\s]+\z/)
      record.errors.add(attribute, options[:message] || "は日本語、英数字で入力してください")
    end
  end
end 