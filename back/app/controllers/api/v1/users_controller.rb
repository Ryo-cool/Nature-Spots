class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
  before_action :set_user, only: [:show, :update]

  def create
    @user = User.new(create_user_params)
    @user.activated = true
    authorize @user

    if @user.save
      render_success(
        { user: UserSerializer.new(@user).as_json },
        status: :created
      )
    else
      render json: {
        errors: @user.errors.messages,
        error: @user.errors.full_messages,
        message: @user.errors.full_messages.first,
        status: :unprocessable_entity
      }, status: :unprocessable_entity
    end
  end

  def show
    authorize @user
    result = UserDataService.call(@user)

    if result.success?
      render_success({ **result.data, status: :ok })
    else
      render_error(result.errors)
    end
  end

  def update
    authorize @user

    if @user.update(user_params)
      render_success(
        user: UserSerializer.new(@user).as_json,
        status: :ok
      )
    else
      render_error(@user.errors.full_messages)
    end
  end

  def my_page
    render_success(
      user: UserSerializer.new(current_user).as_json,
      status: :ok
    )
  end

  def user_data
    result = UserDataService.call(current_user)

    if result.success?
      render_success({ **result.data, status: :ok })
    else
      render_error(result.errors)
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
