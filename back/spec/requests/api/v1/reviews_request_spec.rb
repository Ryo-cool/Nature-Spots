# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Reviews", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  describe "GET /api/v1/reviews" do
    before do
      create_list(:review, 5, spot: spot)
    end

    it "レビュー一覧を取得できること" do
      get "/api/v1/reviews"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['reviews'].size).to eq(5)
      expect(json['pagination']).to include(
        'current_page' => 1,
        'total_count' => 5
      )
    end

    it "ページネーションが正しく動作すること" do
      get "/api/v1/reviews", params: { page: 1, per_page: 2 }

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['reviews'].size).to eq(2)
      expect(json['pagination']['per_page']).to eq(2)
      expect(json['pagination']['total_pages']).to eq(3)
    end

    it "レビューにユーザー情報が含まれること" do
      get "/api/v1/reviews"

      json = JSON.parse(response.body)
      first_review = json['reviews'].first
      expect(first_review['user']).to include('id', 'name')
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
