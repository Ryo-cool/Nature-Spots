class Api::V1::PrefecturesController < ApplicationController
  before_action :set_prefecture, only: [:show]

  def index
    @prefectures = Prefecture.all
    render json: @prefectures
  end

  def show
    @spots = Spot.where(prefecture_id: @prefecture.id)
    render json: {
      prefecture: serialize_active_hash(@prefecture),
      spot: @spots
    }
  end

  private

  def set_prefecture
    @prefecture = Prefecture.find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound.new("Couldn't find Prefecture", "Prefecture") if @prefecture.nil?
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
