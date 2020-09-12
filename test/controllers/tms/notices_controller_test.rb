require 'test_helper'

module TMS
  class NoticesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @confirmed_staff_admin = admins(:confirmed_staff_admin)
      @draft_tender_notice = tender_notices(:boom_barriers)
    end

    teardown do
      @draft_tender_notice = nil
      @confirmed_board_admin = @confirmed_staff_admin = nil
    end

    test 'unauthenticated access should redirect' do
      get tms_notices_url
      assert_redirected_to new_admin_session_url
    end

    test 'should access index' do
      sign_in @confirmed_board_admin, scope: :admin

      get tms_notices_url
      assert_response :success

      sign_out :admin
    end

    test 'should create tender notice' do
      sign_in @confirmed_board_admin, scope: :admin

      assert_difference('TenderNotice.count') do
        post tms_notices_url, params: {
          notice: {
            reference_token: 'ABC-9876-x_y_z',
            title: 'Tender Notice Title'
          }
        }
      end

      assert_redirected_to tms_notice_url(TenderNotice.last)

      sign_out :admin
    end

    test 'should update tender notice' do
      sign_in @confirmed_board_admin, scope: :admin

      assert_difference('TenderNotice.count', 0) do
        put tms_notice_url(@draft_tender_notice), params: {
          notice: {
            title: 'updated title for the draft'
          }
        }
      end

      assert_equal 'updated title for the draft', @draft_tender_notice.reload.title
      assert_redirected_to tms_notice_url(@draft_tender_notice)

      sign_out :admin
    end

    test 'should delete a tender notie' do
      sign_in @confirmed_board_admin, scope: :admin

      assert_difference('TenderNotice.count', -1) do
        delete tms_notice_url(@draft_tender_notice)
      end

      assert_redirected_to tms_notices_url

      sign_out :admin
    end
  end
end