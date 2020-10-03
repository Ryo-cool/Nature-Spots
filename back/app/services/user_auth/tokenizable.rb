module UserAuth
  module Tokenizable

    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def from_token(token)
        auth_token = AuthToken.new(token: token)
        from_token_payload(auth_token.payload)
      end

      private
        def from_token_payload(payload)
          find(payload["sub"])
        end
    end
    
    # トークンを返す
    def to_token
      AuthToken.new(payload: to_token_payload).token
    end

    # 有効期限付きのトークンを返す
    def to_lifetime_token(lifetime)
      auth = AuthToken.new(lifetime: lifetime, payload: to_token_payload)
      { token: auth.token, lifetime_text: auth.lifetime_text }
    end

    private
      def to_token_payload
        { sub: id }
      end
  end
end