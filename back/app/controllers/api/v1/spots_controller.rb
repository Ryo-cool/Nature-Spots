class Api::V1::SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :update, :destroy]
  before_action :set_prefecture, only: [:show]
  # before_action :set_location, only: [:show]
  # GET /spots
  def index
    @spots = Spot.includes(:prefecture, :location).all
    @prefecture = Prefecture.all
    @location = Location.all
    render json: {
      spots: @spots, 
      prefecture: @prefecture,
      location: @location,
      status: :ok
    }
  end

  # GET /spots/1
  def show
    @reviews = @spot.reviews.includes(:user)
    @prefecture = @spot.prefecture
    @location = @spot.location
    # お気に入り機能
    favorites = Favorite.where(spot_id: @spot.id).pluck(:user_id)
    @favorite_user = User.find(favorites)
    render json: {
      spot: @spot,
      prefecture: @prefecture,
      location: @location,
      favuser: @favorite_user,
      review: @reviews.to_json(include: [:user]),
      status: :ok
    }
  end
  
  # レビュー数順にスポットを表示する
  def ranking
    spot_ids = Review.group(:spot_id).order('count(spot_id) desc').limit(5).pluck(:spot_id)
    @all_ranks = Spot.includes(:prefecture, :location).find(spot_ids)

    render json: {
      spots: @all_ranks.to_json(methods: [:review_count]),
      status: :ok
    }
  end

  # SPOT /spots
  def create
    @spot = Spot.new(spot_params)
    if @spot.save
      render json: @spot
    else
      render json: @spot.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /spots/1
  def update
    if @spot.update(spot_params)
      render json: @spot
    else
      render json: @spot.errors, status: :unprocessable_entity
    end
  end

  # DELETE /spots/1
  def destroy
    @spot.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spot
      @spot = Spot.find(params[:id])
    end

    def set_user
      @user = User.find(params[:id])
    end

    def set_prefecture
      @prefecture = Prefecture.find(params[:id])
    end

    def set_location
      @location = Location.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def spot_params
      params
      .permit(
        :name,
        :introduction,
        :location_id,
        :photo,
        :longitude,
        :latitude,
        :address,
        :prefecture_id
      )
    end
end
