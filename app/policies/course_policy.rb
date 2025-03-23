class CoursePolicy < ApplicationPolicy
  def index?
    user.dean? || user.teacher?
  end

  def show?
    user.dean? || (user.teacher? && record.teacher_id == user.id)
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
      elsif user.teacher?
        scope.where(teacher_id: user.id)
      else
        scope.none
      end
    end
  end
end
