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
    # @prefecture = Spot.includes(:prefecture)
    
    render json:{
      location: @location,
      spot: @jspot,
      
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
