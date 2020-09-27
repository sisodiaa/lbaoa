require 'test_helper'

class TenderProposalSelectionFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @under_review_notice = tender_notices(:water_purifier)
    @selected_proposal = tender_proposals(:waterwala)
  end

  teardown do
    @selected_proposal = nil
    @under_review_notice = nil
    @confirmed_board_admin = nil
  end

  test 'successful selection of a proposal for the tender notice' do
    @under_review_notice.proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end

    sign_in @confirmed_board_admin, scope: :admin

    assert @under_review_notice.under_review?
    assert_nil @under_review_notice.selection_reason
    assert @selected_proposal.pending?

    post tms_proposal_selection_url(@under_review_notice), params: {
      proposal_selection_form: {
        token: @selected_proposal.token,
        selection_reason: 'Good service and cost'
      }
    }

    assert @under_review_notice.reload.archived?
    assert_equal 'Good service and cost', @under_review_notice.selection_reason
    assert @selected_proposal.reload.selected?

    sign_out :admin
  end
end
