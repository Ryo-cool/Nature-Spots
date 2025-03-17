class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user
  
  def show
    @user = User.find(params[:id])
    #レビュー
    @reviews = @user.reviews.includes(:spot)
    #お気に入り
    favorites = Favorite.where(user_id: @user.id).pluck(:spot_id)
    @favorite_list = Spot.includes(:prefecture, :location).find(favorites)
    #いいね
    @likes = Like.where(user_id: @user.id).includes(:review)
    # フォロー
    follow = Relationship.where(user_id: @user.id).pluck(:follow_id)
    @follow_list = User.find(follow)
    # フォロワー
    follower = Relationship.where(follow_id: @user.id).pluck(:user_id)
    @follower_list = User.find(follower)
    render json: {
      user: @user,
      reviews: @reviews.to_json(include: [:spot]),
      favorite: @favorite_list,
      like: @likes,
      follow: @follow_list,
      follower: @follower_list,
      status: :ok
    }

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
    @user = User.find(current_user.id)
    @likes = Like.where(user_id: current_user.id).includes(:review)
    @reviews = @user.reviews.includes(:spot)
    @like_reviews = @user.liked_reviews.includes(:spot, :user)
    # お気に入り機能
    favorites = Favorite.where(user_id: current_user.id).pluck(:spot_id)
    @favorite_list = Spot.includes(:prefecture, :location).find(favorites)
    # フォロー
    follow = Relationship.where(user_id: current_user.id).pluck(:follow_id)
    @follow_list = User.find(follow)
    # フォロワー
    follower = Relationship.where(follow_id: current_user.id).pluck(:user_id)
    @follower_list = User.find(follower)
    
    render json: {
      review: @reviews.to_json(include: [:spot]), 
      like_reviews: @like_reviews.to_json(include: [:spot,:user]), 
      user: @user, 
      favorite: @favorite_list,
      follow: @follow_list,
      follower: @follower_list
    }
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :image, :introduction)
  end

end
