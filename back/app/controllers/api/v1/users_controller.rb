class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user
  before_action :set_user, only: [:show, :update]

  def show
    result = UserDataService.call(@user)
    
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

  def update
    if @user.update(user_params)
      serialized_user = UserSerializer.new(@user).as_json
      render json: {
        user: serialized_user,
        status: :ok
      }
    else
      render json: {
        errors: @user.errors.full_messages,
        status: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end

  def my_page
    serialized_user = UserSerializer.new(current_user).as_json
    render json: {
      user: serialized_user,
      status: :ok
    }
  end

  def user_data
    result = UserDataService.call(current_user)
    
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

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :image, :introduction)
  end
end
