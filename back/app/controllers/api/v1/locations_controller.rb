class Api::V1::LocationsController < ApplicationController
  before_action :set_location, only: [:show]
  before_action :set_spot, only: [:show]
  # before_action :set_prefecture, only: [:show]
  def index
    @locations= Location.all
    render json: @locations
  end

  def show
    @jspot= Spot.where(location_id: @location.id)
    @prefecture = Spot.includes(:prefecture)
    @prefecture= Prefecture.all
    render json:{
      location: @location,
      spot: @jspot,
      prefecture: @prefecture
    } 
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def set_spot
    @spot = Spot.find(params[:id])
  end

end
