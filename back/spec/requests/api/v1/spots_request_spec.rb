require 'rails_helper'

RSpec.describe "Api::V1::Spots", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot, user: user) }
  let(:headers) { auth_headers(user) }

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
    let!(:review) { create(:review, spot: spot, user: user, rating: 4, wentday: '5') }
    let!(:like) { create(:like, review: review) }

    it "特定のスポットを取得できること" do
      get "/api/v1/spots/#{spot.id}"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['spot']).to include(
        'id' => spot.id,
        'name' => spot.name,
        'prefecture_id' => spot.prefecture_id,
        'location_id' => spot.location_id
      )
      expect(json['spot']['photo']).to include('url')

      expect(json['spot']['reviews']).to be_an(Array)
      first_review = json['spot']['reviews'].first
      expect(first_review).to include(
        'id' => review.id,
        'title' => review.title,
        'text' => review.text,
        'rating' => review.rating,
        'wentday' => review.wentday
      )
      expect(first_review['image']).to include('url')
      expect(first_review['user']).to include('id' => review.user.id, 'name' => review.user.name)
      expect(first_review['likes']).to be_an(Array)
      expect(first_review['likes'].first).to include('user_id' => like.user_id)

      expect(json['review']).to eq(json['spot']['reviews'])
      expect(json['prefecture']['attributes']['name']).to eq(Prefecture.find(spot.prefecture_id).name)
      expect(json['location']['attributes']['name']).to eq(Location.find(spot.location_id).name)
      expect(json['reviews_count']).to eq(spot.reviews.count)

      average_rating = (spot.reviews.sum(:rating).to_f / spot.reviews.count).round(1)
      expect(json['average_rating']).to eq(average_rating)
      expect(json['favuser']).to be_nil
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

  describe "GET /api/v1/spots/seasonal" do
    let!(:spring_spot) { create(:spot, :with_season, season_id: 1, user: user) }
    let!(:summer_spot) { create(:spot, :with_season, season_id: 2, user: user) }

    it "指定された季節のスポットのみを返すこと" do
      get "/api/v1/spots/seasonal", params: { season: 'spring' }
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['season']['key']).to eq('spring')
      expect(json['spots'].map { |s| s['id'] }).to contain_exactly(spring_spot.id)
      expect(json['spots'].first['seasons']).to be_an(Array)
      expect(json['spots'].first['seasons'].first['key']).to eq('spring')
    end

    it "季節未指定の場合は現在月の季節を返すこと" do
      travel_to Date.new(2026, 7, 15) do
        get "/api/v1/spots/seasonal"
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['season']['key']).to eq('summer')
        expect(json['spots'].map { |s| s['id'] }).to contain_exactly(summer_spot.id)
      end
    end

    it "無効な季節が指定された場合は422を返すこと" do
      get "/api/v1/spots/seasonal", params: { season: 'invalid' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
