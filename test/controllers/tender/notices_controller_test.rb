require 'test_helper'

module Tender
  class NoticesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @published_tender_notice = tender_notices(:air_quality_monitors)
    end

    teardown do
      @published_tender_notice = nil
    end

    test 'should get index and its variants' do
      get tender_notices_url
      assert_response :success

      get upcoming_tender_notices_url
      assert_response :success

      get current_tender_notices_url
      assert_response :success

      get under_review_tender_notices_url
      assert_response :success

      get archived_tender_notices_url
      assert_response :success
    end

    test 'should get show' do
      attach_file_to_record(
        @published_tender_notice.build_document.attachment, 'tender_notice.xlsx'
      )
      @published_tender_notice.save

      get tender_notice_url(@published_tender_notice)
      assert_response :success
    end
  end
end
