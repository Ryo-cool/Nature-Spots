# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Announcements", type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:user) { create(:user) }

  describe "GET /api/v1/announcements" do
    let!(:published) { create(:announcement) }
    let!(:draft) { create(:announcement, :draft) }

    it "公開済みのお知らせのみ返すこと" do
      get "/api/v1/announcements", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      ids = json['announcements'].map { |a| a['id'] }
      expect(ids).to include(published.id)
      expect(ids).not_to include(draft.id)
    end
  end

  describe "POST /api/v1/announcements" do
    let(:valid_params) { { announcement: { title: "重要なお知らせ", body: "本日メンテナンスを実施します。" } } }

    context "管理者の場合" do
      it "お知らせを作成し、全アクティブユーザーへ通知を fan-out すること" do
        create_list(:user, 2)

        expect {
          post "/api/v1/announcements", params: valid_params, headers: auth_headers(admin)
        }.to change(Announcement, :count).by(1)

        expect(response).to have_http_status(:created)
        # admin + 作成済み2ユーザー全員に通知が届く
        expect(Notification.where(action: :announcement).count).to eq(User.where(activated: true).count)
      end
    end

    context "一般ユーザーの場合" do
      it "403を返すこと" do
        post "/api/v1/announcements", params: valid_params, headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "未認証ユーザーの場合" do
      it "401を返すこと" do
        post "/api/v1/announcements", params: valid_params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
