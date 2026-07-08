class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
  before_action :set_user, only: [:show, :update]

  def create
    @user = User.new(create_user_params)
    @user.activated = true

    if @user.save
      serialized_user = UserSerializer.new(@user).as_json
      render json: {
        user: serialized_user,
        status: :created
      }, status: :created
    else
      render json: {
        errors: @user.errors.messages,
        message: @user.errors.full_messages.first,
        status: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end

  def show
    authorize @user
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
    authorize @user

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

  def create_user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :image, :introduction)
  end
end
