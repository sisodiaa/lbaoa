require 'test_helper'

module Tender
  class ProposalsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @current_notice = tender_notices(:barb_wire)
      @proposal = tender_proposals(:wirewala)
    end

    teardown do
      @proposal = nil
      @current_notice = nil
    end

    test 'should get index' do
      archived_notice = tender_notices(:water_purifier)

      archived_notice.proposals.each do |proposal|
        attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
      end

      get tender_notice_proposals_url(archived_notice), xhr: true
      assert_response :success
    end

    test 'index is only accessible for archived notices' do
      skip
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
  end
end
