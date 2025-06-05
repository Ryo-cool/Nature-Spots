class Api::V1::SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]

  # GET /spots
  def index
    @spots = Spot.all
    serialized_spots = @spots.map { |spot| SpotSerializer.new(spot).as_json }
    
    render json: {
      spots: serialized_spots,
      prefectures: Prefecture.all,
      locations: Location.all,
      status: :ok
    }
  end

  # GET /spots/1
  def show
    serialized_spot = SpotSerializer.new(@spot).as_json
    
    render json: {
      **serialized_spot,
      status: :ok
    }
  end
  
  # レビュー数順にスポットを表示する
  def ranking
    result = SpotRankingService.call
    
    if result.success?
      render json: {
        **result.data,
        status: :ok
      }
    else
      render json: {
        errors: result.errors,
        status: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end

  # POST /spots
  def create
    @spot = current_user.spots.build(spot_params)
    authorize(@spot)
    
    if @spot.save
      serialized_spot = SpotSerializer.new(@spot).as_json
      render json: {
        spot: serialized_spot,
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
    authorize(@spot)
    
    if @spot.update(spot_params)
      serialized_spot = SpotSerializer.new(@spot).as_json
      render json: {
        spot: serialized_spot,
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
    authorize(@spot)
    
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
