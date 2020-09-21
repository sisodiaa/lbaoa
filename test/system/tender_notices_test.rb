require 'application_system_test_case'

class TenderNoticesTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
  end

  teardown do
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
    assert_no_selector '.tender-notice-proposals'

    visit current_tender_notices_url

    assert_selector '.active', text: 'Current'
    assert_selector '.tender-notices.row'
    assert_selector '.tender-notice', count: 1
    within('.tender-notice-proposals') do
      assert_selector 'a.btn', text: 'Submit your proposal'
    end

    visit under_review_tender_notices_url

    assert_selector '.active', text: 'Under Review'
    assert_selector '.tender-notices.row'
    assert_selector '.tender-notice', count: 1
    within('.tender-notice-proposals') do
      assert_selector 'a.btn', text: 'View Propsoals'
    end

    visit archived_tender_notices_url

    assert_selector '.active', text: 'Archived'
    assert_selector '.tender-notices.row'
    assert_selector '.tender-notice', count: 1
    within('.tender-notice-proposals') do
      assert_selector 'a.btn', text: 'View Propsoals'
    end
  end

  test 'list proposals for under review tender notice' do
    tender_notices(:water_purifier).proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end

    visit under_review_tender_notices_url

    click_on 'View Propsoals'

    within('#tenderProposalsTableModalBody') do
      assert_selector '#tenderProposalsTableBody tr', count: 3
    end
  end

  test 'list proposals for archived notice' do
    tender_notices(:elevator_buttons).proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end

    visit archived_tender_notices_url

    click_on 'View Propsoals'

    within('#tenderProposalsTableModalBody') do
      assert_selector '#tenderProposalsTableBody tr', count: 1
    end
  end
end
