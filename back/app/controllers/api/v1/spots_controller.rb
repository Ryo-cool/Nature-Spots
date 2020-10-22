class Api::V1::SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :update, :destroy]
  before_action :set_prefecture, only: [:show]
  # GET /spots
  def index
    @spots = Spot.all
    @prefecture = Prefecture.all
    @location = Location.all
    render json: {spots: @spots, prefecture: @prefecture,location: @location }
  end

  # GET /spots/1
  def show
    @reviews = @spot.reviews.includes(:spot).order('created_at DESC')
    @location = Location.find(params[:id])
    render json: {spot: @spot, prefecture: @prefecture, location: @location, review: @reviews}
  end

  # SPOT /spots
  def create
    @spot = Spot.new(spot_params)

    if @spot.save
      render json: @spot, status: :created, location: @spot
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

    def set_prefecture
      @prefecture = Prefecture.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def spot_params
      params.require(:spot)
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
