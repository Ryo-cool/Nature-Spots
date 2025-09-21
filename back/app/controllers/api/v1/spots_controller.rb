class Api::V1::SpotsController < ApplicationController
  before_action :set_spot, only: [:show, :update, :destroy]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user, only: [:create, :update, :destroy]

  # GET /spots
  def index
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 20).to_i
    offset = (page - 1) * per_page
    
    # Fix: Include nested user associations for reviews and favorites to prevent N+1 queries
    # Note: prefecture and location are ActiveHash, not ActiveRecord, so don't include them
    @spots = Spot.includes(:user, 
                          reviews: :user, 
                          favorites: :user)
                 .offset(offset)
                 .limit(per_page)
                 .order(created_at: :desc)
    
    # Calculate total count for manual pagination
    total_count = Spot.count
    total_pages = (total_count.to_f / per_page).ceil
    
    serialized_spots = @spots.map { |spot| SpotSerializer.new(spot).as_json }
    
    # ActiveHash data is already in memory, no need to cache
    @prefectures = Prefecture.all
    @locations = Location.all
    
    render json: {
      spots: serialized_spots,
      prefectures: @prefectures,
      locations: @locations,
      pagination: {
        current_page: page,
        total_pages: total_pages,
        total_count: total_count,
        per_page: per_page
      },
      status: :ok
    }
  end

  # GET /spots/1
  def show
    serializer = SpotSerializer.new(@spot)
    detailed_spot = serializer.with_details
    reviews_count = detailed_spot[:reviews_count] || detailed_spot[:review_count]

    render json: {
      spot: detailed_spot,
      review: detailed_spot[:reviews],
      reviews_count: reviews_count,
      average_rating: detailed_spot[:average_rating],
      prefecture: serializer.prefecture_resource,
      location: serializer.location_resource,
      favuser: favorite_user_id_for_current_user,
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
    # Fix: Include nested user associations for reviews and favorites to prevent N+1 queries
    # Note: prefecture and location are ActiveHash, not ActiveRecord, so don't include them
    @spot = Spot.includes(:user,
                         { reviews: [:user, :likes] },
                         favorites: :user).find(params[:id])
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

  def favorite_user_id_for_current_user
    return nil unless defined?(current_user) && current_user

    @spot.favorites.find { |favorite| favorite.user_id == current_user.id }&.user_id
  end
end
