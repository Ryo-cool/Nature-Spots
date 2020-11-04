class Api::V1::PrefecturesController < ApplicationController
  before_action :set_prefecture, only: [:show]
  before_action :set_spot, only: [:show]
  def index
    @prefectures= Prefecture.all
    render json: @prefectures
  end

  def show
    @reviews = @spot.review
    @pspot= Spot.where(prefecture_id: @prefecture.id)
    render json:{prefecture: @prefecture,spot: @pspot,review: @reviews} 
  end

  private

  def set_prefecture
    @prefecture = prefecture.find(params[:id])
  end

  def set_spot
    @spot = Spot.find(params[:id])
  end

end
