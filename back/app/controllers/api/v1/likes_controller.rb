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

  def like_params
    params.permit(:review_id, :user_id)
  end

  def set_review
    @review = Review.find(like_params[:review_id] || params[:review_id])
  end

  def render_likes(status: :ok)
    render json: { likes: @review.likes.reload }, status: status
  end
end
