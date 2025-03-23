class AddressPolicy < ApplicationPolicy
  def index?
    true # Everyone can see addresses
  end

  def show?
    true
  end

  def create?
    user.dean? || user.teacher?
  end

  def update?
    user.dean? || user.teacher?
  end

  def destroy?
    user.dean?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end 