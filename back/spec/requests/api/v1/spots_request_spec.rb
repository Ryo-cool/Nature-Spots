require 'rails_helper'

RSpec.describe "Api::V1::Spots", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot, user: user) }
  let(:headers) { { 'Authorization' => "Bearer #{generate_jwt_token(user)}" } }

  describe "GET /api/v1/spots" do
    before do
      create_list(:spot, 3)
    end

    it "スポット一覧を取得できること" do
      get "/api/v1/spots"
      expect(response).to have_http_status(:ok)
      
      json = JSON.parse(response.body)
      expect(json['spots'].size).to eq(3)
      expect(json['prefectures']).to be_present
      expect(json['locations']).to be_present
    end
  end

  describe "GET /api/v1/spots/:id" do
    it "特定のスポットを取得できること" do
      get "/api/v1/spots/#{spot.id}"
      expect(response).to have_http_status(:ok)
      
      json = JSON.parse(response.body)
      expect(json['id']).to eq(spot.id)
      expect(json['name']).to eq(spot.name)
    end

    it "存在しないスポットの場合404を返すこと" do
      get "/api/v1/spots/999999"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/spots" do
    let(:valid_params) do
      {
        name: "新しいスポット",
        address: "東京都新宿区テスト1-1-1",
        introduction: "新しいスポットの説明",
        prefecture_id: 13,
        location_id: 1,
        photo: fixture_file_upload(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
      }
    end

    context "認証済みユーザーの場合" do
      it "スポットを作成できること" do
        expect {
          post "/api/v1/spots", params: valid_params, headers: headers
        }.to change(Spot, :count).by(1)
        
        expect(response).to have_http_status(:created)
      end
    end

    context "未認証ユーザーの場合" do
      it "401を返すこと" do
        post "/api/v1/spots", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  private

  def generate_jwt_token(user)
    UserAuth::AuthToken.new(payload: { sub: user.id }).token
  end
end
