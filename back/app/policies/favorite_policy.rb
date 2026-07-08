class FavoritePolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def destroy?
    user.present? && owner?
  end

  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end
end
