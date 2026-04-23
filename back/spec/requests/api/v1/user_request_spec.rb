require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do
    let(:valid_params) do
      {
        name: "山田太郎",
        email: "new-user@example.com",
        password: "Password123",
        password_confirmation: "Password123"
      }
    end

    it "未認証でユーザー登録できること" do
      expect {
        post "/api/v1/users", params: valid_params
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      created_user = User.find_by!(email: "new-user@example.com")
      expect(created_user).to be_activated
      expect(json['user']).to include(
        'id' => created_user.id,
        'name' => "山田太郎",
        'email' => "new-user@example.com"
      )
      expect(json['status']).to eq("created")
    end

    it "不正な入力の場合は422を返すこと" do
      expect {
        post "/api/v1/users", params: valid_params.merge(email: "invalid", password: "weak")
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json['errors']).to be_present
    end

    it "登録済みメールアドレスの場合は422を返すこと" do
      create(:user, email: "new-user@example.com")

      expect {
        post "/api/v1/users", params: valid_params
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json['errors']).to be_present
    end
  end

  describe "GET /api/v1/users/:id" do
    let(:user) { create(:user) }

    it "未認証の場合は401を返すこと" do
      get "/api/v1/users/#{user.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end

end
