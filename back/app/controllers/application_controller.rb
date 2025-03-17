class ApplicationController < ActionController::API
  include ActionController::Cookies
  include UserAuth::Authenticator

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

  def record_not_found(exception)
    render json: {
      error: "#{exception.model} not found",
      status: :not_found
    }, status: :not_found
  end

  def parameter_missing(exception)
    render json: {
      error: exception.message,
      status: :unprocessable_entity
    }, status: :unprocessable_entity
  end

  def record_invalid(exception)
    render json: {
      error: exception.record.errors.full_messages,
      status: :unprocessable_entity
    }, status: :unprocessable_entity
  end
end
