class Api::V1::FavoritesController < ApplicationController
  before_action :authenticate_user
  before_action :set_spot

  # お気に入り登録
  def create
    @favorite = Favorite.new(user_id: current_user.id, spot_id: @spot.id)
    if @favorite.save
      render json: { favorite: FavoriteSerializer.new(@favorite).with_spot }, status: :created
    else
      render json: { error: @favorite.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # お気に入り削除
  def destroy
    @favorite = Favorite.find_by!(user_id: current_user.id, spot_id: @spot.id)
    @favorite.destroy!
    render json: { message: "お気に入りを削除しました" }, status: :ok
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
