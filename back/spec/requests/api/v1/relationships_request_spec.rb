require 'rails_helper'

RSpec.describe "Api::V1::Relationships", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:headers) { auth_headers(user) }

  describe "POST /api/v1/relationships" do
    it "フォローできること" do
      expect {
        post "/api/v1/relationships", params: { follow_id: other_user.id }, headers: headers
      }.to change(Relationship, :count).by(1)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['relationship']).to be_present
      expect(json['user']['id']).to eq(other_user.id)
    end

    it "未認証の場合は401を返すこと" do
      post "/api/v1/relationships", params: { follow_id: other_user.id }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /api/v1/relationships/:id" do
    before { user.follow(other_user) }

    it "フォロー解除できること" do
      expect {
        delete "/api/v1/relationships/#{other_user.id}",
               params: { follow_id: other_user.id },
               headers: headers
      }.to change(Relationship, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
