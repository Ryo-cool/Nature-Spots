# frozen_string_literal: true

module AuthHelpers
  # JWTトークンを生成する
  def generate_jwt_token(user)
    UserAuth::AuthToken.new(payload: { sub: user.id }).token
  end

  # 認証用ヘッダーを返す
  def auth_headers(user)
    { 'Authorization' => "Bearer #{generate_jwt_token(user)}" }
  end

  # Cookieベースの認証用ヘルパー
  def login_as(user)
    token = generate_jwt_token(user)
    cookies[UserAuth.token_access_key] = token
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
