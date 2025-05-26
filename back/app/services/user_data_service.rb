class UserDataService < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    data = {
      user: UserSerializer.new(user).as_json,
      reviews: fetch_user_reviews,
      liked_reviews: fetch_liked_reviews,
      favorites: fetch_favorite_spots,
      followings: fetch_followings,
      followers: fetch_followers
    }
    
    success(data)
  rescue StandardError => e
    failure(["ユーザーデータの取得に失敗しました: #{e.message}"])
  end

  private

  attr_reader :user

  def fetch_user_reviews
    user.reviews.includes(:spot).map do |review|
      ReviewSerializer.new(review).with_spot
    end
  end

  def fetch_liked_reviews
    user.liked_reviews.includes(:spot, :user).map do |review|
      ReviewSerializer.new(review).with_associations
    end
  end

  def fetch_favorite_spots
    user.favorite_spots.includes(:prefecture, :location).map do |spot|
      SpotSerializer.new(spot).as_json
    end
  end

  def fetch_followings
    user.followings.map { |following| UserSerializer.new(following).as_json }
  end

  def fetch_followers
    user.followers.map { |follower| UserSerializer.new(follower).as_json }
  end
end 