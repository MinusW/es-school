class QuarterPolicy < ApplicationPolicy
  def index?
    true # Everyone can see quarters
  end

  def show?
    true
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
      if user.dean?
        scope.all
      else
        scope.not_archived
      end
    end
  end
end
