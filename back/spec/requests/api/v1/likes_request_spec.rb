require 'rails_helper'

RSpec.describe "Api::V1::Likes", type: :request do
  let(:user) { create(:user) }
  let(:review) { create(:review) }
  let(:headers) { { 'Authorization' => "Bearer #{generate_jwt_token(user)}" } }

  describe "POST /api/v1/spots/:spot_id/reviews/:review_id/likes" do
    let(:other_user) { create(:user) }

    it "creates a like for the current user and returns the updated likes array" do
      expect do
        post "/api/v1/spots/#{review.spot_id}/reviews/#{review.id}/likes",
             params: { review_id: review.id, user_id: other_user.id },
             headers: headers
      end.to change(Like, :count).by(1)

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json['likes']).to be_an(Array)
      expect(json['likes']).to include(include('user_id' => user.id, 'review_id' => review.id))
      expect(json['likes']).not_to include(include('user_id' => other_user.id))
    end
  end

  describe "DELETE /api/v1/spots/:spot_id/reviews/:review_id/likes/:id" do
    let!(:like) { create(:like, user: user, review: review) }

    it "destroys the like and returns the refreshed likes array" do
      expect do
        delete "/api/v1/spots/#{review.spot_id}/reviews/#{review.id}/likes/#{like.id}",
               headers: headers
      end.to change(Like, :count).by(-1)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['likes']).to eq([])
    end
  end

  private

  def generate_jwt_token(user)
    UserAuth::AuthToken.new(payload: { sub: user.id }).token
  end
end
