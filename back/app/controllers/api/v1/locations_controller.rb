class Api::V1::LocationsController < ApplicationController

  def index
    @locations= Location.all
    render json: @locations
  end

  def show
  end

end
