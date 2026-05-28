# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Notifications", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  describe "GET /api/v1/notifications" do
    let!(:unread) { create(:notification, recipient: user, read_at: nil) }
    let!(:read) { create(:notification, recipient: user, read_at: Time.current) }
    let!(:others) { create(:notification, recipient: other_user) }

    context "認証済みユーザーの場合" do
      it "自分の通知一覧と未読数を返すこと" do
        get "/api/v1/notifications", headers: auth_headers(user)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['notifications'].size).to eq(2)
        expect(json['unread_count']).to eq(1)
        expect(json['pagination']['total_count']).to eq(2)
      end

      it "他人の通知は含まれないこと" do
        get "/api/v1/notifications", headers: auth_headers(user)
        json = JSON.parse(response.body)
        ids = json['notifications'].map { |n| n['id'] }
        expect(ids).not_to include(others.id)
      end
    end

    context "未認証ユーザーの場合" do
      it "401を返すこと" do
        get "/api/v1/notifications"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "GET /api/v1/notifications/unread_count" do
    it "未読数を返すこと" do
      create_list(:notification, 2, recipient: user, read_at: nil)
      create(:notification, recipient: user, read_at: Time.current)

      get "/api/v1/notifications/unread_count", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['unread_count']).to eq(2)
    end
  end

  describe "PATCH /api/v1/notifications/:id/read" do
    let!(:notification) { create(:notification, recipient: user, read_at: nil) }

    it "通知を既読にできること" do
      patch "/api/v1/notifications/#{notification.id}/read", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(notification.reload.read_at).to be_present
      expect(JSON.parse(response.body)['notification']['read']).to be true
    end

    it "他人の通知は既読にできないこと（404）" do
      others = create(:notification, recipient: other_user, read_at: nil)
      patch "/api/v1/notifications/#{others.id}/read", headers: auth_headers(user)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /api/v1/notifications/read_all" do
    it "全通知を既読にできること" do
      create_list(:notification, 3, recipient: user, read_at: nil)

      patch "/api/v1/notifications/read_all", headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['unread_count']).to eq(0)
      expect(user.notifications.unread.count).to eq(0)
    end
  end
end
