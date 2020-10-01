class EmailValidator < ActiveModel::EachValidator

# emailのカスタムバリデーション
# user.rbに[require "validator/email_validator"]を追加する
# 詳しくは  https://blog.cloud-acct.com/posts/u-rails-custom-eachvalidator を参照

  def validate_each(record, attribute, value)
    # text length
    max = 255
    record.errors.add(attribute, :too_long, count: max) if value.length > max

    # format
    format = /\A\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*\z/
    record.errors.add(attribute, :invalid) unless format =~ value

    # uniqueness
    record.errors.add(attribute, :taken) if record.email_activated?
  end

end