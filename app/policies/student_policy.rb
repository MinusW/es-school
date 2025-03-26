class StudentPolicy < ApplicationPolicy
  def index?
    user.dean?
  end

  def show?
    user.dean? || (user.student? && user.students.include?(record))
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

  def generate_pdf?
    user.dean? || (user.student? && user.students.include?(record))
  end

  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.student?
        scope.where(user: user)
      else
        scope.none
      end
    end
  end
end
