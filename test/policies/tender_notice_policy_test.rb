require 'test_helper'

class TenderNoticePolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @draft_tender_notice = tender_notices(:boom_barriers)
    @published_tender_notice = tender_notices(:air_quality_monitors)
  end

  teardown do
    @draft_tender_notice = @published_tender_notice = nil
    @confirmed_board_admin = nil
  end

  test '#edit' do
    assert TenderNoticePolicy.new(@confirmed_board_admin, @draft_tender_notice).edit?
    assert_not TenderNoticePolicy.new(@confirmed_board_admin, @published_tender_notice).edit?
  end

  test '#update' do
    assert TenderNoticePolicy.new(@confirmed_board_admin, @draft_tender_notice).update?
    assert_not TenderNoticePolicy.new(@confirmed_board_admin, @published_tender_notice).update?
  end

  test '#destroy' do
    assert TenderNoticePolicy.new(@confirmed_board_admin, @draft_tender_notice).destroy?
    assert_not TenderNoticePolicy.new(@confirmed_board_admin, @published_tender_notice).destroy?
  end
end
