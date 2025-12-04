# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Reviews", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  describe "GET /api/v1/spots/:spot_id/reviews" do
    before do
      create_list(:review, 5, spot: spot)
    end

    it "スポットのレビュー一覧を取得できること" do
      get "/api/v1/spots/#{spot.id}/reviews"

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /api/v1/spots/:spot_id/reviews" do
    let(:valid_params) do
      {
        title: "素晴らしいスポット",
        text: "自然が豊かでとてもリラックスできました。また来たいです。",
        rating: 5,
        wentday: '3',
        image: fixture_file_upload(Rails.root.join('spec/fixtures/test_image.jpg'), 'image/jpeg')
      }
    end

    context "認証済みユーザーの場合" do
      it "レビューを作成できること" do
        expect {
          post "/api/v1/spots/#{spot.id}/reviews",
               params: valid_params,
               headers: auth_headers(user)
        }.to change(Review, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['review']).to include(
          'title' => "素晴らしいスポット",
          'rating' => 5
        )
      end

      it "作成したレビューが正しいユーザーに紐付くこと" do
        post "/api/v1/spots/#{spot.id}/reviews",
             params: valid_params,
             headers: auth_headers(user)

        expect(Review.last.user_id).to eq(user.id)
        expect(Review.last.spot_id).to eq(spot.id)
      end
    end

    context "未認証ユーザーの場合" do
      it "401を返すこと" do
        post "/api/v1/spots/#{spot.id}/reviews", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "バリデーションエラーの場合" do
      let(:invalid_params) do
        {
          title: "あ", # 2文字未満
          text: "短い", # 10文字未満
          rating: 6 # 範囲外
        }
      end

      it "422を返しエラーメッセージが含まれること" do
        post "/api/v1/spots/#{spot.id}/reviews",
             params: invalid_params,
             headers: auth_headers(user)

        expect(response).to have_http_status(:unprocessable_entity)

        json = JSON.parse(response.body)
        expect(json['error']).to be_present
      end
    end
  end
end
