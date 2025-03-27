class GradePolicy < ApplicationPolicy
  def index?
    user.dean? || user.teacher? || user.student?
  end

  def show?
    user.dean? ||
    (user.teacher? && record.teacher_id == user.id) ||
    (user.student? && record.student.user_id == user.id)
  end

  def create?
    user.teacher? || user.dean?
  end

  def update?
    user.dean? || (user.teacher? && record.teacher_id == user.id)
  end

  def destroy?
    user.dean? || (user.teacher? && record.teacher_id == user.id)
  end

  class Scope < Scope
    def resolve
      if user.dean?
        scope.all
      elsif user.teacher?
        scope.where(teacher_id: user.id)
      elsif user.student?
        # Find all grades for this student
        student_ids = Student.where(user_id: user.id).pluck(:id)
        scope.where(student_id: student_ids)
      else
        scope.none
      end
    end
  end
end
