class DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    record.documentable.draft? || record.documentable.is_a?(Post)
  end
end
