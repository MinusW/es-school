class ClassroomPolicy < ApplicationPolicy
  def index?
    true # Everyone can see the classrooms list
  end

  def show?
    true # Everyone can see individual classroom details
  end

  def calendar?
    true # Everyone can see the calendar
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
        # Deans can see all classrooms
        scope.all
      elsif user.teacher?
        # Teachers can see classrooms they teach
        teacher = user.teacher
        scope.where(teacher_id: teacher.id)
      elsif user.student?
        # Students can see classrooms they're enrolled in
        scope.where(id: user.classrooms.pluck(:id))
      else
        # Other users can see all non-archived classrooms
        scope.where(is_archived: [ false, nil ])
      end
    end
  end
end
