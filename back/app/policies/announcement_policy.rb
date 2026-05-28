class AnnouncementPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    user.present? && user.admin?
  end
end
