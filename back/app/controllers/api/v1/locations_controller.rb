class Api::V1::LocationsController < ApplicationController
  before_action :set_location, only: [:show]

  def index
    @locations= Location.all
    render json: @locations
  end

  def show
    @spots = Location.spots
    render json:{location: @location, spots: @spots} 
  end

  private
  def set_location
    @location = Location.find(params[:id])
  end
end
