class TenderProposalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      raise Pundit::NotAuthorizedError unless scope.first.tender_notice.archived?

      scope.all
    end
  end

  def create?
    record.tender_notice.current?
  end

  def new?
    record.tender_notice.current?
  end
end
