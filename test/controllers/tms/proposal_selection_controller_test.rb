require 'test_helper'

module TMS
  class ProposalSelectionControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @confirmed_staff_admin = admins(:confirmed_staff_admin)
      @under_review_notice = tender_notices(:water_purifier)
      @selected_proposal = tender_proposals(:waterwala)
    end

    teardown do
      @selected_proposal = nil
      @under_review_notice = nil
      @confirmed_board_admin = @confirmed_staff_admin = nil
    end

    test 'unauthenticated access should redirect' do
      post tms_proposal_selection_url(@under_review_notice), params: {
        proposal_selection_form: {
          token: @selected_proposal.token,
          selection_reason: 'Good service and cost'
        }
      }

      assert_redirected_to new_admin_session_url
    end

    test 'successful selection of a proposal for the tender notice' do
      @under_review_notice.proposals.each do |proposal|
        attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
      end

      sign_in @confirmed_board_admin, scope: :admin

      post tms_proposal_selection_url(@under_review_notice), params: {
        proposal_selection_form: {
          token: @selected_proposal.token,
          selection_reason: 'Good service and cost'
        }
      }

      assert_redirected_to tms_notice_url(@under_review_notice)

      sign_out :admin
    end

    test 'that staff admin can not select a proposal' do
      @under_review_notice.proposals.each do |proposal|
        attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
      end

      sign_in @confirmed_staff_admin, scope: :admin

      post tms_proposal_selection_url(@under_review_notice), params: {
        proposal_selection_form: {
          token: @selected_proposal.token,
          selection_reason: 'Good service and cost'
        }
      }

      assert_redirected_to admin_root_url
      assert_equal 'You cannot perform this action.', flash[:error]

      sign_out :admin
    end
  end
end
