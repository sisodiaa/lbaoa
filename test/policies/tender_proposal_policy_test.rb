require 'test_helper'

class TenderProposalPolicyTest < ActiveSupport::TestCase
  setup do
    @upcoming_tender_notice = tender_notices(:air_quality_monitors)
    @current_tender_notice = tender_notices(:barb_wire)
    @archived_tender_notice = tender_notices(:water_purifier)
  end

  teardown do
    @archived_tender_notice = @current_tender_notice = @upcoming_tender_notice = nil
  end

  test '#create' do
    assert TenderProposalPolicy.new(nil, @current_tender_notice.proposals.build).create?
    assert_not TenderProposalPolicy.new(nil, @upcoming_tender_notice.proposals.build).create?
    assert_not TenderProposalPolicy.new(nil, @archived_tender_notice.proposals.build).create?
  end

  test '#new' do
    assert TenderProposalPolicy.new(nil, @current_tender_notice.proposals.build).new?
    assert_not TenderProposalPolicy.new(nil, @upcoming_tender_notice.proposals.build).new?
    assert_not TenderProposalPolicy.new(nil, @archived_tender_notice.proposals.build).new?
  end

  test 'scope' do
    proposals = TenderProposalPolicy::Scope
                .new(nil, @archived_tender_notice.proposals).resolve

    assert_includes proposals, tender_proposals(:waterwala)

    assert_raises(Pundit::NotAuthorizedError) do
      TenderProposalPolicy::Scope
        .new(nil, @current_tender_notice.proposals).resolve
    end

    assert_raises(Pundit::NotAuthorizedError) do
      TenderProposalPolicy::Scope
        .new(nil, @upcoming_tender_notice.proposals).resolve
    end
  end
end
