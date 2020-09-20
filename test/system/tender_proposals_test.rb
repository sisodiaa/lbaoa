require "application_system_test_case"

class TenderProposalsTest < ApplicationSystemTestCase
  setup do
    @current_notice = tender_notices(:barb_wire)
  end

  teardown do
    @current_notice = nil
  end

  test 'that proposal submission form displays validation errors' do
    visit new_tender_notice_proposal_url(@current_notice)

    within('.tender-proposal-notice-info') do
      assert_selector 'h5', text: @current_notice.title
      assert_selector 'small.text-muted',
                      text: @current_notice.reference_token
    end

    within('form') do
      click_on 'Create Tender proposal'

      assert_selector '.invalid-feedback', text: "Name can't be blank"
      assert_selector '.invalid-feedback', text: 'Email is invalid'
      assert_selector '.invalid-feedback', text: "Email can't be blank"
      assert_selector '.invalid-feedback', text: "Document attachment can't be absent"
    end
  end

  test 'successful submission of proposal' do
    visit new_tender_notice_proposal_url(@current_notice)

    fill_in 'proposal_name', with: 'vendor name'
    fill_in 'proposal_email', with: 'vendor@example.com'
    attach_file 'proposal_document_attributes_attachment',
                Rails.root.join('test/fixtures/files/sheet.xlsx'),
                visible: false

    click_on 'Create Tender proposal'

    assert_selector '.toast-header strong', text: 'Success'
    assert_selector '.toast-body',
                    text: 'Proposal submitted successfully. '\
                          'You will also receive a confirmation on the given email address.'
  end
end
