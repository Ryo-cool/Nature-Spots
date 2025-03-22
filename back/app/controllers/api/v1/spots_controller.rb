class Api::V1::SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]

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
    @favorite_users = User.where(id: Favorite.where(spot_id: @spot.id).pluck(:user_id))
    render json: {
      spot: @spot,
      prefecture: @spot.prefecture,
      location: @spot.location,
      favuser: @favorite_users,
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

  # POST /spots
  def create
    @spot = Spot.new(spot_params)
    if @spot.save
      render json: {
        spot: @spot,
        status: :created
      }, status: :created
    else
      render json: {
        errors: @spot.errors.full_messages,
        status: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /spots/1
  def update
    if @spot.update(spot_params)
      render json: {
        spot: @spot,
        status: :ok
      }
    else
      render json: {
        errors: @spot.errors.full_messages,
        status: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end

  # DELETE /spots/1
  def destroy
    if @spot.destroy
      render json: { status: :no_content }, status: :no_content
    else
      render json: {
        errors: @spot.errors.full_messages,
        status: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:id])
  end

  def spot_params
    params.permit(
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
