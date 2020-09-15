require 'test_helper'

class OpenTenderNoticeJobTest < ActiveJob::TestCase
  setup do
    @notice = tender_notices(:air_quality_monitors)
  end

  teardown do
    @notice = nil
  end

  test 'tender notice state changes to current' do
    assert @notice.upcoming?

    OpenTenderNoticeJob.perform_now(@notice.reference_token)

    assert @notice.reload.current?
  end
end
