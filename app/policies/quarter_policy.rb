class QuarterPolicy < ApplicationPolicy
  def index?
    user.dean? || user.teacher?
  end

  def show?
    user.dean? || user.teacher?
  end

  def create?
    user.dean?
  end

  def update?
    user.dean?
  end

  def destroy?
    user.dean?
  end

  class Scope < Scope
    def resolve
      if user.dean? || user.teacher?
        scope.all
      else
        scope.none
      end
    end
  end
end
