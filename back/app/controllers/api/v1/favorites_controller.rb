class Api::V1::FavoritesController < ApplicationController
  before_action :set_spot
  before_action :authenticate_user

  # お気に入り登録
  def create
    if @spot.user_id != current_user.id   # 投稿者本人以外に限定
      @favorite = Favorite.create(user_id: current_user.id, spot_id: @spot.id)
      render json: @favorite
    end
  end
  # お気に入り削除
  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, spot_id: @spot.id)
    @favorite.destroy
    render json: @favorite
  end

  private
  def set_spot
    @spot = spot.find(params[:spot_id])
  end
end
