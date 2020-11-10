class Api::V1::LikesController < ApplicationController
  before_action :set_review

  def create
    like = Like.new(like_params)
    if like.save
      render status: :created
    end
  end

  def destroy
    @like = current_user.likes.find_by(review_id: @review.id)
    @like.destroy
    render json: @like
  end

  private
  def like_params
    params.require(:like).permit(:review_id, :user_id)
  end

  def set_review
    @review = Review.find(params[:review_id])
  end

end
