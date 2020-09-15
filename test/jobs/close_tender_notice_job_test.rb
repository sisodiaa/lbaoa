require 'test_helper'

class CloseTenderNoticeJobTest < ActiveJob::TestCase
  setup do
    @notice = tender_notices(:barb_wire)
  end

  teardown do
    @notice = nil
  end

  test 'tender notice state changes to archived' do
    assert @notice.current?

    CloseTenderNoticeJob.perform_now(@notice.reference_token)

    assert @notice.reload.archived?
  end
end
