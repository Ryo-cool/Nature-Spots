class Api::V1::ReviewsController < ApplicationController
  # before_action :set_spot,only:[:create]

  def index
    @reviews= Review.all
    @users = User.includes(:reviews)
    render json: {review: @reviews,user: @users}
  end


  def create
    @review = Review.new(review_params)
    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  private
  def review_params
    params.permit(:title,:text,:image,:wentday,:rating).merge(user_id: current_user.id, spot_id: params[:spot_id])
  end

  def set_spot
    @spot = Spot.find(params[:id])
  end
end
