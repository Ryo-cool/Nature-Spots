class ReviewPolicy < ApplicationPolicy
  def create?
    user.present?
  end

  def update?
    user.present? && owner?
  end

  def destroy?
    user.present? && owner?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
