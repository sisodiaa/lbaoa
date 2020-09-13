class TenderNoticePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    record.draft?
  end

  def update?
    record.draft?
  end

  def destroy?
    record.draft?
  end
end
