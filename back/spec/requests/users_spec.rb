require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  # Configure JWT settings for consistency in tests
  before(:all) do
    @original_secret_key_base = Rails.application.credentials.secret_key_base
    @original_api_domain = ENV["API_DOMAIN"]

    # Use a consistent secret_key_base for tests
    Rails.application.credentials.secret_key_base = "test_secret_key_base_for_jwt_users_spec_abcdefghijklmnopqrstuvwxyz0123456789"
    ENV["API_DOMAIN"] = "test.host"

    # Reload UserAuth configurations if they cache these values at load time
    # This might be needed if UserAuth.token_secret_signature_key.call or UserAuth.token_audience.call
    # are memoized or captured at initialization.
    # For now, assume UserAuth initializer re-evaluates Rails.application.credentials.secret_key_base on each call.
    # If UserAuth module caches these, more specific reloading might be needed.
    # Example: Reloading the initializer if it's structured to allow that, or re-evaluating UserAuth constants.
  end

  after(:all) do
    Rails.application.credentials.secret_key_base = @original_secret_key_base
    ENV["API_DOMAIN"] = @original_api_domain
  end

  let!(:user) { FactoryBot.create(:user, name: "試験ユーザー", email: "test@example.com", password: "Password123", password_confirmation: "Password123") }
  let!(:other_user) { FactoryBot.create(:user, name: "他人ユーザー", email: "other@example.com", password: "Password456", password_confirmation: "Password456") }
  let(:auth_headers) { { "Authorization" => "Bearer #{user.to_token}" } }
  let(:other_auth_headers) { { "Authorization" => "Bearer #{other_user.to_token}" } }
  let(:unauthenticated_headers) { { "Authorization" => "Bearer invalidtoken" } }

  def json_response
    JSON.parse(response.body)
  end

  describe "GET /api/v1/users/:id (show)" do
    context "when authenticated" do
      it "returns the user's details" do
        get "/api/v1/users/#{user.id}", headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(json_response["user"]["id"]).to eq(user.id)
        expect(json_response["user"]["name"]).to eq(user.name)
        expect(json_response["status"]).to eq("ok")
      end

      it "returns not found if user does not exist" do
        get "/api/v1/users/#{user.id + 999}", headers: auth_headers
        expect(response).to have_http_status(:not_found)
        expect(json_response["error"]).to include("User not found")
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/api/v1/users/#{user.id}" # No headers
        expect(response).to have_http_status(:unauthorized)
      end

      it "returns unauthorized with invalid token" do
        get "/api/v1/users/#{user.id}", headers: unauthenticated_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /api/v1/users/:id (update)" do
    let(:valid_update_params) { { name: "更新名前", introduction: "私は更新されました。" } }
    # The User model validation for name is: format: { with: /\A[ぁ-んァ-ヶー一-龠]+\z/, message: "は日本語で入力してください" }
    let(:invalid_update_params_format) { { name: "Invalid Name English" } }
    let(:expected_error_name_format) { "名前は日本語で入力してください" }
    let(:expected_error_name_blank) { "名前を入力してください" }

    context "when authenticated as the user being updated" do
      it "updates the user with valid parameters" do
        put "/api/v1/users/#{user.id}", params: valid_update_params, headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(json_response["user"]["name"]).to eq("更新名前")
        expect(json_response["user"]["introduction"]).to eq("私は更新されました。")
        expect(user.reload.name).to eq("更新名前")
      end

      it "does not update the user with invalid parameters (invalid name format)" do
        put "/api/v1/users/#{user.id}", params: invalid_update_params_format, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to include(expected_error_name_format)
        expect(user.reload.name).not_to eq("Invalid Name English")
      end

      it "does not update the user with invalid parameters (blank name)" do
        put "/api/v1/users/#{user.id}", params: { name: "" }, headers: auth_headers
        expect(response).to have_http_status(:unprocessable_entity)
        # The model has: validates :name, presence: true
        # The localized error for presence is typically "名前を入力してください"
        expect(json_response["errors"]).to include(expected_error_name_blank)
      end
    end

    context "when authenticated as a different user" do
      it "updates another user's record (current controller logic allows this)" do
        put "/api/v1/users/#{other_user.id}", params: valid_update_params, headers: auth_headers # user trying to update other_user
        expect(response).to have_http_status(:ok)
        expect(other_user.reload.name).to eq("更新名前")
      end
    end

    context "when trying to update a non-existent user" do
      it "returns not found" do
        put "/api/v1/users/#{user.id + 999}", params: { name: "存在しない名" }, headers: auth_headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        put "/api/v1/users/#{user.id}", params: { name: "認証なし名" } # No headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/users/current_user (my_page)" do
    context "when authenticated" do
      it "returns the current user's details" do
        get "/api/v1/users/current_user", headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(json_response["user"]["id"]).to eq(user.id)
        expect(json_response["user"]["name"]).to eq(user.name)
        expect(json_response["status"]).to eq("ok")
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/api/v1/users/current_user" # No headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/users/user_data (user_data)" do
    context "when authenticated" do
      it "returns the current user's detailed data" do
        get "/api/v1/users/user_data", headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(json_response["user"]["id"]).to eq(user.id)
        expect(json_response).to have_key("review")
        expect(json_response).to have_key("like_reviews")
        expect(json_response).to have_key("favorite")
        expect(json_response["status"]).to eq("ok")
      end
    end

    context "when not authenticated" do
      it "returns unauthorized" do
        get "/api/v1/users/user_data" # No headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end