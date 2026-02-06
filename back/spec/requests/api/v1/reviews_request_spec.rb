# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Reviews", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  describe "GET /api/v1/spots/:spot_id/reviews" do
    let(:other_spot) { create(:spot) }
    let!(:spot_reviews) { create_list(:review, 5, spot: spot) }
    let!(:other_spot_reviews) { create_list(:review, 2, spot: other_spot) }

    it "対象スポットのレビューのみを取得し、pagination件数も一致すること" do
      get "/api/v1/spots/#{spot.id}/reviews"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      response_review_ids = json['reviews'].map { |review| review['id'] }
      spot_review_ids = spot_reviews.map(&:id)
      other_spot_review_ids = other_spot_reviews.map(&:id)

      expect(json['reviews'].size).to eq(5)
      expect(response_review_ids).to match_array(spot_review_ids)
      expect(response_review_ids & other_spot_review_ids).to be_empty
      expect(Review.where(id: response_review_ids).distinct.pluck(:spot_id)).to eq([spot.id])
      expect(json.dig('pagination', 'total_count')).to eq(5)
      expect(json.dig('pagination', 'total_pages')).to eq(1)
    end

    it "存在しないスポットIDの場合は404を返すこと" do
      get "/api/v1/spots/999999/reviews"

      expect(response).to have_http_status(:not_found)
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
