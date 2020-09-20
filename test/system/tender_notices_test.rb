require 'application_system_test_case'

class TenderNoticesTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @published_tender_notice = tender_notices(:air_quality_monitors)
    @excel_document = documents(:excel)
  end

  teardown do
    @excel_document = nil
    @published_tender_notice = nil
    Warden.test_reset!
  end

  test 'visit tender_notices and its variants' do
    visit tender_notices_url

    assert_selector '.active', text: 'Current'
    assert_selector '.tender-notices.row'
    assert_selector '.tender-notice', count: 1

    visit upcoming_tender_notices_url

    assert_selector '.active', text: 'Upcoming'
    assert_selector '.tender-notices.row'
    assert_selector '.tender-notice', count: 1

    visit current_tender_notices_url

    assert_selector '.active', text: 'Current'
    assert_selector '.tender-notices.row'
    assert_selector '.tender-notice', count: 1

    visit archived_tender_notices_url

    assert_selector '.active', text: 'Archived'
    assert_selector '.tender-notices.row'
    assert_selector '.tender-notice', count: 1
  end

  test 'list proposals for archived tender notice' do
    tender_notices(:water_purifier).proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end

    visit archived_tender_notices_url

    click_on 'View Propsoals'

    within('#tenderProposalsTableModalBody') do
      assert_selector '#tenderProposalsTableBody tr', count: 3
    end
  end
end
