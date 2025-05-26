class ApplicationController < ActionController::API
  include ActionController::Cookies
  include UserAuth::Authenticator
  include Authorization

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from StandardError, with: :internal_server_error
  rescue_from JWT::DecodeError, with: :unauthorized_request
  rescue_from JWT::ExpiredSignature, with: :token_expired

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

  def internal_server_error(exception)
    Rails.logger.error "Internal Server Error: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    
    render json: {
      error: "内部サーバーエラーが発生しました",
      status: :internal_server_error
    }, status: :internal_server_error
  end

  def unauthorized_request(exception)
    render json: {
      error: "認証に失敗しました",
      status: :unauthorized
    }, status: :unauthorized
  end

  def token_expired(exception)
    render json: {
      error: "トークンの有効期限が切れています",
      status: :unauthorized
    }, status: :unauthorized
  end
end
