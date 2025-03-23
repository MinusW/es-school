class ThemePolicy < ApplicationPolicy
  def index?
    # Everyone can see the themes list
    true
  end

  def show?
    # Everyone can see theme details
    true
  end

  def create?
    # Only deans can create themes
    user.dean?
  end

  def update?
    # Only deans can update themes
    user.dean?
  end

  def destroy?
    # Only deans can archive themes
    user.dean?
  end

  class Scope < Scope
    def resolve
      if user.dean?
        # Deans can see all themes
        scope.all
      elsif user.teacher?
        # Teachers can see themes related to courses they teach
        teacher_course_module_ids = Course.where(teacher_id: user.id).pluck(:module_id).uniq
        scope.where(id: teacher_course_module_ids)
      elsif user.student?
        # Students can see themes related to their courses
        student_ids = Student.where(user_id: user.id).pluck(:id)
        classroom_ids = Classroom.joins(:students).where(students: { id: student_ids }).pluck(:id)
        course_module_ids = Course.where(classroom_id: classroom_ids).pluck(:module_id).uniq
        scope.where(id: course_module_ids)
      else
        # Other users can see non-archived themes
        scope.not_archived
      end
    end
  end
end
