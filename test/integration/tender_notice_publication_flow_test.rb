require 'test_helper'

class TenderNoticePublicationFlowTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @draft_tender_notice = tender_notices(:boom_barriers)
    @published_tender_notice = tender_notices(:air_quality_monitors)
  end

  teardown do
    @draft_tender_notice = @published_tender_notice = nil
    @confirmed_board_admin = @confirmed_staff_admin = nil
  end

  test 'ensure that background jobs are scheduled upon publishing tender notice' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )
    @draft_tender_notice.save

    sign_in @confirmed_board_admin, scope: :admin

    assert_enqueued_jobs 1, queue: :default do
      patch publish_tms_notice_url(@draft_tender_notice), params: {
        notice: {
          publish_notice: true
        }
      }
    end

    assert_enqueued_with(
      job: OpenTenderNoticeJob,
      args: [@draft_tender_notice.reference_token],
      at: @draft_tender_notice.opening_on,
      queue: 'default'
    )

    perform_enqueued_jobs queue: :default

    assert_enqueued_jobs 2, queue: :default

    assert_enqueued_with(
      job: CloseTenderNoticeJob,
      args: [@draft_tender_notice.reference_token],
      at: @draft_tender_notice.closing_on,
      queue: 'default'
    )

    assert_performed_jobs 2

    assert_performed_with(
      job: OpenTenderNoticeJob,
      args: [@draft_tender_notice.reference_token],
      at: @draft_tender_notice.opening_on,
      queue: 'default'
    )

    assert_performed_with(
      job: CloseTenderNoticeJob,
      args: [@draft_tender_notice.reference_token],
      at: @draft_tender_notice.closing_on,
      queue: 'default'
    )

    sign_out :admin
  end
end
