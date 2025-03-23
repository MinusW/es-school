class RoomPolicy < ApplicationPolicy
  def index?
    true # Everyone can see rooms
  end

  def show?
    true
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
      else
        scope.where(is_archived: [ false, nil ])
      end
    end
  end
end
