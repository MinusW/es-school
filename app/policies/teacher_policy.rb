class TeacherPolicy < ApplicationPolicy
  def index?
    true # Everyone can see teachers list
  end

  def show?
    true # Everyone can see teacher details
  end

  def create?
    user.dean? # Only deans can create teachers
  end

  def update?
    user.dean? || record.user_id == user.id # Deans or the teacher themselves
  end

  def destroy?
    user.dean? # Only deans can delete teachers
  end

  def calendar?
    return true if user.dean? # Deans can see all calendars
    return true if record.user_id == user.id # Teachers can see their own calendar
    
    # Students can only see calendars of teachers who teach their classes
    if user.student?
      user.classrooms.any? do |classroom|
        classroom.teacher_id == record.id || classroom.courses.not_archived.where(teacher_id: record.id).exists?
      end
    else
      false # Other users cannot see calendars
    end
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
