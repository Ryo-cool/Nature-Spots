# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::UserTokens", type: :request do
  describe "POST /api/v1/user_token" do
    let(:user) { create(:user, email: 'test@example.com', password: 'Password123') }

    context "有効な認証情報の場合" do
      let(:valid_params) do
        { auth: { email: user.email, password: 'Password123' } }
      end

      it "ログインに成功しトークンが発行されること" do
        post "/api/v1/user_token", params: valid_params

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['exp']).to be_present
        expect(json['user']).to include(
          'id' => user.id,
          'email' => user.email,
          'name' => user.name
        )
      end

      it "Cookieにトークンが設定されること" do
        post "/api/v1/user_token", params: valid_params

        expect(response.cookies[UserAuth.token_access_key.to_s]).to be_present
      end
    end

    context "無効なメールアドレスの場合" do
      let(:invalid_email_params) do
        { auth: { email: 'wrong@example.com', password: 'Password123' } }
      end

      it "404を返すこと" do
        post "/api/v1/user_token", params: invalid_email_params
        expect(response).to have_http_status(:not_found)
      end
    end

    context "無効なパスワードの場合" do
      let(:invalid_password_params) do
        { auth: { email: user.email, password: 'WrongPassword123' } }
      end

      it "404を返すこと" do
        post "/api/v1/user_token", params: invalid_password_params
        expect(response).to have_http_status(:not_found)
      end
    end

    context "アクティベートされていないユーザーの場合" do
      let(:inactive_user) { create(:user, :inactive) }
      let(:inactive_params) do
        { auth: { email: inactive_user.email, password: 'Password123' } }
      end

      it "404を返すこと" do
        post "/api/v1/user_token", params: inactive_params
        expect(response).to have_http_status(:not_found)
      end
    end

    context "パラメータが空の場合" do
      it "エラーを返すこと" do
        post "/api/v1/user_token", params: { auth: { email: '', password: '' } }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/v1/user_token" do
    let(:user) { create(:user) }

    it "ログアウトに成功すること" do
      delete "/api/v1/user_token", headers: auth_headers(user)
      expect(response).to have_http_status(:ok)
    end

    it "Cookieが削除されること" do
      delete "/api/v1/user_token", headers: auth_headers(user)
      expect(response.cookies[UserAuth.token_access_key.to_s]).to be_nil
    end
  end
end
