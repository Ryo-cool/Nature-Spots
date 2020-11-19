class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user
  
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
    
  end

  def my_page
    # @review =Review.find(params[:id])
    # @reviews= @review.reviews
    render json: current_user.my_json
  end

  def user_data
    @likes= Like.where(user_id: current_user.id)
    @user = User.find(current_user.id)
    @reviews = @user.reviews
    @like_reviews= @user.liked_reviews
    # 投稿したスポット
    render json: {review: @reviews, like_reviews: @like_reviews}
  end


end
