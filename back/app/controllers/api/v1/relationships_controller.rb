class Api::V1::RelationshipsController < ApplicationController
  before_action :authenticate_user
  before_action :set_user

  def create
    @relationship = current_user.active_relationships.build(follow_id: @user.id)
    if @relationship.save
      render json: {
        relationship: RelationshipSerializer.new(@relationship).as_json,
        user: UserSerializer.new(@user).with_associations
      }, status: :created
    else
      render json: { error: @relationship.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @relationship = current_user.active_relationships.find_by!(follow_id: @user.id)
    @relationship.destroy!
    render json: {
      message: "フォローを解除しました",
      user: UserSerializer.new(@user).with_associations
    }, status: :ok
  end

  private

  def set_user
    @user = User.find(params[:follow_id])
  end
end
