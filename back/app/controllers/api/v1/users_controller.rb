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
    # お気に入り機能
    favorites = Favorite.where(user_id: current_user.id).pluck(:spot_id)
    @favorite_list = Spot.find(favorites)
    # 投稿したスポット
    render json: {review: @reviews, like_reviews: @like_reviews, user: @user, favorite: @favorite_list}
  end

  private

  def user_params
    params.permit(:name, :email, :password_digest,:image,:introduction)
  end

end
