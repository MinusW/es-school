class ClassroomPolicy < ApplicationPolicy
  def index?
    true # Everyone can see the index
  end

  def show?
    true # Everyone can see individual classrooms
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
      scope.all # Return all classrooms for all users
    end
  end
end
