require 'test_helper'

class TenderNoticeProposalFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @current_notice = tender_notices(:barb_wire)
  end

  teardown do
    @current_notice = nil
  end

  test 'that propsoal and document are created together' do
    assert_difference('TenderProposal.count') do
      assert_difference('Document.count') do
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
      end
    end

    assert_not_nil TenderProposal.last.token
  end
end
