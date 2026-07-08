require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "POST /api/v1/users" do
    let(:valid_params) do
      {
        name: "新規ユーザー",
        email: "newuser@example.com",
        password: "Password123"
      }
    end

    it "ユーザーを作成できること" do
      expect {
        post "/api/v1/users", params: valid_params
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['user']['email']).to eq("newuser@example.com")
      expect(User.find_by(email: "newuser@example.com").activated).to be true
    end

    it "不正なパラメータの場合は422を返すこと" do
      post "/api/v1/users", params: { name: "a", email: "bad", password: "short" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "GET /api/v1/users/:id" do
    it "ユーザーデータを取得できること" do
      get "/api/v1/users/#{other_user.id}", headers: headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['user']['id']).to eq(other_user.id)
    end
  end

  describe "PATCH /api/v1/users/:id" do
    it "本人は更新できること" do
      patch "/api/v1/users/#{user.id}",
            params: { name: "更新後ネーム", introduction: "自己紹介" },
            headers: headers

      expect(response).to have_http_status(:ok)
      expect(user.reload.name).to eq("更新後ネーム")
    end

    it "他人の更新は403を返すこと" do
      patch "/api/v1/users/#{other_user.id}",
            params: { name: "不正更新" },
            headers: headers

      expect(response).to have_http_status(:forbidden)
      expect(other_user.reload.name).not_to eq("不正更新")
    end

    it "未認証の場合は401を返すこと" do
      patch "/api/v1/users/#{user.id}", params: { name: "更新" }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET /api/v1/users/user_data" do
    it "自分のユーザーデータを取得できること" do
      get "/api/v1/users/user_data", headers: headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['user']['id']).to eq(user.id)
      expect(json).to include('reviews', 'liked_reviews', 'favorites', 'followings', 'followers')
    end
  end
end
