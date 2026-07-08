class Api::V1::FavoritesController < ApplicationController
  before_action :authenticate_user
  before_action :set_spot

  def create
    @favorite = Favorite.new(user_id: current_user.id, spot_id: @spot.id)
    authorize @favorite

    if @favorite.save
      render_success(
        { favorite: FavoriteSerializer.new(@favorite).with_spot },
        status: :created
      )
    else
      render_error(@favorite.errors.full_messages)
    end
  end

  def destroy
    @favorite = Favorite.find_by!(user_id: current_user.id, spot_id: @spot.id)
    authorize @favorite
    @favorite.destroy!
    render_success({ message: "お気に入りを削除しました" })
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
