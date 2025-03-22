class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user
  before_action :set_user, only: [:show, :update]

  def show
    render json: {
      user: @user,
      reviews: @user.reviews.includes(:spot).to_json(include: [:spot]),
      favorite: @user.favorite_spots.includes(:prefecture, :location),
      like: @user.likes.includes(:review),
      follow: @user.followings,
      follower: @user.followers,
      status: :ok
    }
  end

  def update
    if @user.update(user_params)
      render json: {
        user: @user,
        status: :ok
      }
    else
      render json: {
        errors: @user.errors.full_messages,
        status: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end

  def my_page
    render json: {
      user: current_user.my_json,
      status: :ok
    }
  end

  def user_data
    render json: {
      review: current_user.reviews.includes(:spot).to_json(include: [:spot]),
      like_reviews: current_user.liked_reviews.includes(:spot, :user).to_json(include: [:spot, :user]),
      user: current_user,
      favorite: current_user.favorite_spots.includes(:prefecture, :location),
      follow: current_user.followings,
      follower: current_user.followers,
      status: :ok
    }
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :image, :introduction)
  end
end
