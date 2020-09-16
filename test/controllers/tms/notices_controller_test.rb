require 'test_helper'

module TMS
  class NoticesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @confirmed_staff_admin = admins(:confirmed_staff_admin)
      @draft_tender_notice = tender_notices(:boom_barriers)
      @published_tender_notice = tender_notices(:air_quality_monitors)
    end

    teardown do
      @draft_tender_notice = @published_tender_notice = nil
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

    test 'that published tender notice can not be edited' do
      sign_in @confirmed_board_admin, scope: :admin

      get edit_tms_notice_url(@published_tender_notice)

      assert_equal 'Published Tender Notice can not be edited.', flash[:error]
      assert_redirected_to admin_root_url

      sign_out :admin
    end

    test 'that published tender notice can not be updated' do
      sign_in @confirmed_board_admin, scope: :admin

      patch tms_notice_url(@published_tender_notice), params: {
        notice: {
          title: 'updated title'
        }
      }

      assert_equal 'Published Tender Notice is not updateable.', flash[:error]
      assert_redirected_to admin_root_url

      sign_out :admin
    end

    test 'that published tender notice can not be destroyed' do
      sign_in @confirmed_board_admin, scope: :admin

      delete tms_notice_url(@published_tender_notice)

      assert_equal 'Published Tender Notice can not be destroyed.', flash[:error]
      assert_redirected_to admin_root_url

      sign_out :admin
    end

    test 'that invalid publishing request renders nothing' do
      sign_in @confirmed_board_admin, scope: :admin

      patch publish_tms_notice_url(@draft_tender_notice), params: {
        notice: {
          publish_notice: 'random_value'
        }
      }

      assert_empty response.body
      assert_response :success

      sign_out :admin
    end

    test 'that validation failure will render error on show' do
      sign_in @confirmed_board_admin, scope: :admin

      patch publish_tms_notice_url(@draft_tender_notice), params: {
        notice: {
          publish_notice: true
        }
      }

      assert_response :success

      sign_out :admin
    end

    test 'that successful publication redirects to show itself' do
      attach_file_to_record(
        @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
      )
      @draft_tender_notice.save

      sign_in @confirmed_board_admin, scope: :admin

      patch publish_tms_notice_url(@draft_tender_notice), params: {
        notice: {
          publish_notice: true
        }
      }

      assert_equal 'Tender Notice was successfully published.', flash[:success]

      assert_redirected_to tms_notice_url(@draft_tender_notice)

      sign_out :admin
    end

    test 'that staff member can not publish tender notice' do
      attach_file_to_record(
        @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
      )
      @draft_tender_notice.save

      sign_in @confirmed_staff_admin, scope: :admin

      patch publish_tms_notice_url(@draft_tender_notice), params: {
        notice: {
          publish_notice: true
        }
      }

      assert_equal 'Only board member can publish a tender notice.', flash[:error]

      assert_redirected_to admin_root_url

      sign_out :admin
    end
  end
end
