module UserAuth

  mattr_accessor :token_lifetime
  self.token_lifetime = 2.week

  mattr_accessor :token_audience
  self.token_audience = -> {
    ENV["API_DOMAIN"]
  }

  mattr_accessor :token_signature_algorithm
  self.token_signature_algorithm = "HS256"

  mattr_accessor :token_secret_signature_key
  self.token_secret_signature_key = -> {
    # Use credentials if available, otherwise fall back to config (for test environment)
    Rails.application.credentials.secret_key_base || Rails.application.config.secret_key_base
  }

  mattr_accessor :token_public_key
  self.token_public_key = nil

  mattr_accessor :token_access_key
  self.token_access_key = :access_token

  mattr_accessor :not_found_exception_class
  self.not_found_exception_class = ActiveRecord::RecordNotFound
end