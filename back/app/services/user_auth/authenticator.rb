module UserAuth
  module Authenticator
    private

      # リクエストヘッダーからトークンを取得する
      def token_from_request_headers
        request.headers["Authorization"]&.split&.last
      end

      # クッキーのオブジェクトキー(config/initializers/user_auth.rb)
      def token_access_key
        UserAuth.token_access_key
      end

      # トークンの取得(リクエストヘッダー優先)
      def token
        token_from_request_headers || cookies[token_access_key]
      end
      
      # トークンからユーザーを取得する
      def fetch_entity_from_token
        AuthToken.new(token: token).entity_for_user
      rescue ActiveRecord::RecordNotFound, JWT::DecodeError, JWT::EncodeError
        nil
      end
  end
end