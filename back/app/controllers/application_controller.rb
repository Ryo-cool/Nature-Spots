class ApplicationController < ActionController::API
  include ActionController::Cookies
  include UserAuth::Authenticator
  include Authorization
  include Api::Response

  # 順序重要: 後に定義されたものが優先される
  # StandardErrorは最も一般的なので最初に（最低優先度）
  rescue_from StandardError, with: :internal_server_error
  # より具体的なエラーを後に（優先度高）
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from JWT::DecodeError, with: :unauthorized_request
  rescue_from JWT::ExpiredSignature, with: :token_expired
  # StandardErrorより後に定義し、認可エラーが500にならないようにする
  rescue_from Authorization::NotAuthorizedError, with: :user_not_authorized

  private

  def record_not_found(exception)
    model_name = if exception.respond_to?(:model) && exception.model.present?
                   exception.model
                 else
                   "Resource"
                 end
    render json: {
      error: "#{model_name} not found",
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

  def unauthorized_request(_exception)
    render json: {
      error: "認証に失敗しました",
      status: :unauthorized
    }, status: :unauthorized
  end

  def token_expired(_exception)
    render json: {
      error: "トークンの有効期限が切れています",
      status: :unauthorized
    }, status: :unauthorized
  end
end
