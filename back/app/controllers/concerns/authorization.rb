module Authorization
  extend ActiveSupport::Concern

  included do
    rescue_from NotAuthorizedError, with: :user_not_authorized
  end

  private

  def authorize(record, query = nil)
    query ||= "#{action_name}?"
    policy = policy_for(record)
    
    unless policy.public_send(query)
      raise NotAuthorizedError, "この操作を実行する権限がありません"
    end
    
    true
  end

  def policy_for(record)
    policy_class = "#{record.class.name}Policy".constantize
    policy_class.new(current_user, record)
  rescue NameError
    ApplicationPolicy.new(current_user, record)
  end

  def user_not_authorized(exception)
    render json: {
      error: exception.message,
      status: :forbidden
    }, status: :forbidden
  end

  class NotAuthorizedError < StandardError; end
end 