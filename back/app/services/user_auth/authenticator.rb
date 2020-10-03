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
  end
end