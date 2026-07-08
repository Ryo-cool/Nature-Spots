require 'rails_helper'

RSpec.describe "Api::V1::Locations", type: :request do
  let(:user) { create(:user) }
  let!(:spot) { create(:spot, user: user, location_id: 1, prefecture_id: 13) }

  describe "GET /api/v1/locations" do
    it "ロケーション一覧を取得できること" do
      get "/api/v1/locations"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      first = json.first
      expect(first['attributes'] || first).to include('id' => 1, 'name' => '海')
    end
  end

  describe "GET /api/v1/locations/:id" do
    it "ロケーションに紐づくスポットを取得できること" do
      get "/api/v1/locations/1"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['location']['attributes']['name']).to eq('海')
      expect(json['spot'].map { |s| s['id'] }).to include(spot.id)
      expect(json['prefecture']).to be_an(Array)
    end

    it "存在しないロケーションの場合は404を返すこと" do
      get "/api/v1/locations/999"
      expect(response).to have_http_status(:not_found)
    end
  end
end
