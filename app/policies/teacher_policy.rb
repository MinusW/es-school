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
