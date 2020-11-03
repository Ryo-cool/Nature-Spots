class Api::V1::LocationsController < ApplicationController
  before_action :set_location, only: [:show]

  def index
    @locations= Location.all
    render json: @locations
  end

  def show
    @jspot= Spot.where(location_id: @location.id)
    render json:{location: @location,spot: @jspot} 
  end

  private
  def set_location
    @location = Location.find(params[:id])
  end
end
