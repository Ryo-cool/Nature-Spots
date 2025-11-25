class Api::V1::ReviewsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]

  def index
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 20).to_i
    offset = (page - 1) * per_page

    @reviews = Review.includes(:user, :spot, :likes)
                     .order(created_at: :desc)
                     .offset(offset)
                     .limit(per_page)

    total_count = Review.count
    total_pages = (total_count.to_f / per_page).ceil

    render json: {
      reviews: @reviews.map { |review| ReviewSerializer.new(review).with_user },
      pagination: {
        current_page: page,
        per_page: per_page,
        total_pages: total_pages,
        total_count: total_count
      }
    }
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      render json: { review: ReviewSerializer.new(@review).with_user }, status: :created
    else
      render json: { error: @review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.permit(:title, :text, :image, :wentday, :rating)
          .merge(user_id: current_user.id, spot_id: params[:spot_id])
  end
end
