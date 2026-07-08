class Api::V1::RelationshipsController < ApplicationController
  before_action :authenticate_user
  before_action :set_user

  def create
    @relationship = current_user.relationships.build(follow_id: @user.id)
    authorize @relationship

    if @relationship.save
      render_success(
        {
          relationship: RelationshipSerializer.new(@relationship).as_json,
          user: UserSerializer.new(@user).with_associations
        },
        status: :created
      )
    else
      render_error(@relationship.errors.full_messages)
    end
  end

  def destroy
    @relationship = current_user.relationships.find_by!(follow_id: @user.id)
    authorize @relationship
    @relationship.destroy!
    render_success(
      message: "フォローを解除しました",
      user: UserSerializer.new(@user).with_associations
    )
  end

  private

  def set_user
    @user = User.find(params[:follow_id])
  end
end
