require 'test_helper'

module Tender
  class ProposalsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @upcoming_notice = tender_notices(:air_quality_monitors)
      @current_notice = tender_notices(:barb_wire)
      @archived_notice = tender_notices(:water_purifier)
      @proposal = tender_proposals(:wirewala)
    end

    teardown do
      @proposal = nil
      @upcoming_notice = @current_notice = @archived_notice = nil
    end

    test 'should get index' do
      @archived_notice.proposals.each do |proposal|
        attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
      end

      get tender_notice_proposals_url(@archived_notice), xhr: true
      assert_response :success
    end

    test 'index is only accessible for archived notices' do
      get tender_notice_proposals_url(@upcoming_notice), xhr: true
      assert_redirected_to root_url
      assert_equal 'You cannot perform this action.', flash[:error]

      get tender_notice_proposals_url(@current_notice), xhr: true
      assert_redirected_to root_url
      assert_equal 'You cannot perform this action.', flash[:error]
    end

    test 'should get show' do
      attach_file_to_record(@proposal.document.attachment, 'sheet.xlsx')

      get tender_proposal_url(@proposal)
      assert_response :success
    end

    test 'should get new' do
      get new_tender_notice_proposal_url(@current_notice)
      assert_response :success
    end

    test 'that proposal can be submitted only for current notices' do
      get new_tender_notice_proposal_url(@upcoming_notice)
      assert_redirected_to root_url
      assert_equal 'You cannot perform this action.', flash[:error]

      get new_tender_notice_proposal_url(@archived_notice)
      assert_redirected_to root_url
      assert_equal 'You cannot perform this action.', flash[:error]
    end

    test 'redirects to show on successful creation' do
      post tender_notice_proposals_url(@current_notice), params: {
        proposal: {
          name: 'Wire Tech',
          email: 'wiretech@example.com',
          document_attributes: {
            attachment: fixture_file_upload(
              'files/sheet.xlsx',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            )
          }
        }
      }

      assert_redirected_to tender_proposal_url(TenderProposal.last)
    end

    test 'that proposal can only be created for current notices' do
      post tender_notice_proposals_url(@archived_notice), params: {
        proposal: {
          name: 'Wire Tech',
          email: 'wiretech@example.com'
        }
      }

      assert_redirected_to root_url
      assert_equal 'You cannot perform this action.', flash[:error]
    end
  end
end
