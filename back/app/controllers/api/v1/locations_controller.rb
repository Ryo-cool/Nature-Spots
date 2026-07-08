class Api::V1::LocationsController < ApplicationController
  before_action :set_location, only: [:show]

  def index
    @locations = Location.all
    render json: @locations
  end

  def show
    @spots = Spot.where(location_id: @location.id)
    @prefectures = Prefecture.all
    render json: {
      location: serialize_active_hash(@location),
      spot: @spots,
      prefecture: @prefectures.map { |p| serialize_active_hash(p) }
    }
  end

  private

  def set_location
    @location = Location.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound.new("Couldn't find Location", "Location") if @location.nil?
  end

  def serialize_active_hash(resource)
    return nil if resource.blank?

    {
      id: resource.id,
      type: resource.class.name.demodulize.underscore,
      attributes: {
        id: resource.id,
        name: resource.name
      }
    }
  end
end
