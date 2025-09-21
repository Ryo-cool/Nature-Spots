class Api::V1::LikesController < ApplicationController
  before_action :authenticate_user
  before_action :set_review

  def create
    like = current_user.likes.new(review: @review)

    if like.save
      render_likes(status: :created)
    else
      render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    like = current_user.likes.find_by!(review_id: @review.id)
    like.destroy

    render_likes
  end

  private

  def set_review
    @review = Review.where(spot_id: params[:spot_id]).find(params[:review_id])
  end

  def render_likes(status: :ok)
    likes = Like
              .where(review_id: @review.id)
              .order(created_at: :asc)
              .select(:id, :review_id, :user_id)

    render json: { likes: likes.as_json(only: %i[id review_id user_id]) }, status: status
  end
end
