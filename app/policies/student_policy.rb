class StudentPolicy < ApplicationPolicy
  def index?
    user.dean? || user.teacher?
  end

  def show?
    user.dean? || user.teacher? || record.user_id == user.id
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
      if user.dean? || user.teacher?
        scope.all
      else
        scope.where(user_id: user.id, is_archived: [ false, nil ])
      end
    end
  end
end
