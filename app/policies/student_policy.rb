class StudentPolicy < ApplicationPolicy
  def index?
    user.dean? || user.student? || user.teacher?
  end

  def show?
    user.dean? ||
    user.teacher? ||
    user.student? && user.students.include?(record)
    
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
    user.dean? || 
    (user.student? && user.students.include?(record)) ||
    (user.teacher? && user.teachers.first.courses.any? { |course| course.classroom_id == record.classroom_id })
  end

  class Scope < Scope
    def resolve
      if user.dean? || user.teacher?
        scope.all
      elsif user.student?
        scope.all
      else
        scope.none
      end
    end
  end
end
