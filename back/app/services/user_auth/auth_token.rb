require 'jwt'

module UserAuth
  class AuthToken
    attr_reader :token
    attr_reader :payload
    attr_reader :lifetime

    def initialize(lifetime: nil, payload: {}, token: nil, options: {})
      if token.present?
        @payload, _ = JWT.decode(token.to_s, decode_key, true, decode_options.merge(options))
        @token = token
      else
        @lifetime = lifetime || UserAuth.token_lifetime
        @payload = claims.merge(payload)
        @token = JWT.encode(@payload, secret_key, algorithm, header_fields)
      end
    end
    private

      # エンコードキー(config/initializers/user_auth.rb)
      def secret_key
        UserAuth.token_secret_signature_key.call
      end

      # デコードキー(config/initializers/user_auth.rb)
      def decode_key
        UserAuth.token_public_key || secret_key
      end
      
      # アルゴリズム(config/initializers/user_auth.rb)
      def algorithm
        UserAuth.token_signature_algorithm
      end
  end
end