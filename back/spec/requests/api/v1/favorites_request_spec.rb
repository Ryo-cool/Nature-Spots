# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Favorites", type: :request do
  let(:user) { create(:user) }
  let(:spot) { create(:spot) }

  describe "POST /api/v1/spots/:spot_id/favorites" do
    context "認証済みユーザーの場合" do
      it "お気に入りを登録できること" do
        expect {
          post "/api/v1/spots/#{spot.id}/favorites",
               headers: auth_headers(user)
        }.to change(Favorite, :count).by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['favorite']).to be_present
      end

      it "同じスポットを重複してお気に入り登録できないこと" do
        create(:favorite, user: user, spot: spot)

        expect {
          post "/api/v1/spots/#{spot.id}/favorites",
               headers: auth_headers(user)
        }.not_to change(Favorite, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "未認証ユーザーの場合" do
      it "401を返すこと" do
        post "/api/v1/spots/#{spot.id}/favorites"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "存在しないスポットの場合" do
      it "404を返すこと" do
        post "/api/v1/spots/999999/favorites",
             headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "DELETE /api/v1/spots/:spot_id/favorites" do
    context "認証済みユーザーの場合" do
      let!(:favorite) { create(:favorite, user: user, spot: spot) }

      it "お気に入りを削除できること" do
        expect {
          delete "/api/v1/spots/#{spot.id}/favorites/#{favorite.id}",
                 headers: auth_headers(user)
        }.to change(Favorite, :count).by(-1)

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['message']).to eq("お気に入りを削除しました")
      end
    end

    context "未認証ユーザーの場合" do
      let!(:favorite) { create(:favorite, user: user, spot: spot) }

      it "401を返すこと" do
        delete "/api/v1/spots/#{spot.id}/favorites/#{favorite.id}"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "他のユーザーのお気に入りを削除しようとした場合" do
      let(:other_user) { create(:user) }
      let!(:other_favorite) { create(:favorite, user: other_user, spot: spot) }

      it "404を返すこと" do
        delete "/api/v1/spots/#{spot.id}/favorites/#{other_favorite.id}",
               headers: auth_headers(user)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
