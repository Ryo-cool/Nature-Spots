class Api::V1::SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user, only: [:create, :update, :destroy]

  # GET /spots
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    
    # Optimize with includes to prevent N+1 queries and add pagination
    @spots = Spot.includes(:prefecture, :location, :user, :reviews)
                 .page(page)
                 .per(per_page)
                 .order(created_at: :desc)
    
    serialized_spots = @spots.map { |spot| SpotSerializer.new(spot).as_json }
    
    # Cache prefecture and location data to avoid repeated queries
    @prefectures = Rails.cache.fetch('prefectures_all', expires_in: 1.hour) do
      Prefecture.all.to_a
    end
    
    @locations = Rails.cache.fetch('locations_all', expires_in: 1.hour) do
      Location.all.to_a
    end
    
    render json: {
      spots: serialized_spots,
      prefectures: @prefectures,
      locations: @locations,
      pagination: {
        current_page: @spots.current_page,
        total_pages: @spots.total_pages,
        total_count: @spots.total_count,
        per_page: per_page.to_i
      },
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
    @spot = Spot.includes(:prefecture, :location, :user, :reviews, :favorites).find(params[:id])
  end

  def record_not_found
    render json: { error: 'Spot not found' }, status: :not_found
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
