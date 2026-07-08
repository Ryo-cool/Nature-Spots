# frozen_string_literal: true

module Api
  module Response
    extend ActiveSupport::Concern

    private

    # 呼び出し例:
    #   render_success({ reviews: [...] })
    #   render_success({ review: ... }, status: :created)
    #   render_success(user: ..., status: :ok)  # status は HTTP ステータス、他は JSON 本体
    def render_success(payload = {}, status: :ok, **rest)
      body = payload.merge(rest)
      render json: body, status: status
    end

    def render_error(messages, status: :unprocessable_entity)
      normalized = Array(messages)
      render json: {
        error: normalized,
        errors: normalized,
        status: status
      }, status: status
    end

    def render_forbidden(message = "この操作を実行する権限がありません")
      render json: {
        error: message,
        status: :forbidden
      }, status: :forbidden
    end
  end
end
