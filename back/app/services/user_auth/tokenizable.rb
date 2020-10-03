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

    private
      def to_token_payload
        { sub: id }
      end
  end
end