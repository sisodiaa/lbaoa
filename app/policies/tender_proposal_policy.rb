class TenderProposalPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      tender_notice = scope.first.tender_notice
      return scope.all if tender_notice.under_review? || tender_notice.archived?

      raise Pundit::NotAuthorizedError
    end
  end

  def create?
    record.tender_notice.current?
  end

  def new?
    record.tender_notice.current?
  end
end
