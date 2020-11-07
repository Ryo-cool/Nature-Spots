class Api::V1::LikesController < ApplicationController
  before_action :set_review

  def create
    @like = Like.create(user_id: current_user.id, review_id: @review.id)
    render json: @like
  end

  def destroy
    @like = current_user.likes.find_by(review_id: @review.id)
    @like.destroy
    render json: @like
  end

  private
  def set_review
    @review = Review.find(params[:review_id])
  end

end
