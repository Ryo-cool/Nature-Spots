require 'rails_helper'

RSpec.describe "Api::V1::Prefectures", type: :request do
  let(:user) { create(:user) }
  let!(:spot) { create(:spot, user: user, prefecture_id: 13, location_id: 1) }

  describe "GET /api/v1/prefectures" do
    it "都道府県一覧を取得できること" do
      get "/api/v1/prefectures"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_an(Array)
      expect(json.size).to eq(47)
    end
  end

  describe "GET /api/v1/prefectures/:id" do
    it "都道府県に紐づくスポットを取得できること" do
      get "/api/v1/prefectures/13"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['prefecture']['attributes']['name']).to eq('東京都')
      expect(json['spot'].map { |s| s['id'] }).to include(spot.id)
    end
  end
end
