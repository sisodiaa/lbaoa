require 'application_system_test_case'

class TMSNoticesTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @confirmed_staff_admin = admins(:confirmed_staff_admin)
    @draft_tender_notice = tender_notices(:boom_barriers)
    @published_tender_notice = tender_notices(:air_quality_monitors)
    @under_review_tender_notice = tender_notices(:water_purifier)
    @archived_tender_notice = tender_notices(:elevator_buttons)
    @current_tender_notice = tender_notices(:barb_wire)
    @excel_document = documents(:excel)
  end

  teardown do
    @excel_document = nil
    @current_tender_notice = nil
    @archived_tender_notice = nil
    @under_review_tender_notice = nil
    @published_tender_notice = nil
    @draft_tender_notice = nil
    @confirmed_board_admin = @confirmed_staff_admin = nil
    Warden.test_reset!
  end

  test 'index all tender notices' do
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notices_url

    assert_selector '.tms-notices__table-row', count: TenderNotice.current.count

    logout :admin
  end

  test 'published tender notice have a download link for the attachment' do
    attach_file_to_record(@excel_document.attachment, 'tender_notice.xlsx')

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@published_tender_notice)

    assert_selector "a[href$='tender_notice.xlsx?disposition=attachment']"

    logout :admin
  end

  test 'show and hide edit controls on show based on publication state' do
    attach_file_to_record(@excel_document.attachment, 'tender_notice.xlsx')

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@published_tender_notice)

    within('.btn-group') do
      assert_no_selector 'a', text: 'Edit'
    end

    visit tms_notice_url(@draft_tender_notice)

    within('.btn-group') do
      assert_selector 'a', text: 'Edit'
    end

    logout :admin
  end

  test 'creating a Tender Notice with insufficient data shows validation errors' do
    login_as @confirmed_board_admin, scope: :admin

    visit admin_root_url

    within(:xpath, "//div[@id='navbarAdmin']") do
      find(:xpath, "//a[@id='dashboard-new-dropdown']").click
      find(:xpath, "//a[@class='dropdown-item'][3]").click
    end

    within('.tms-notice__form') do
      click_on 'Create Tender notice'
    end

    assert_selector '.is-invalid', count: 2
    assert_selector(
      '.invalid-feedback',
      text: 'Reference token only allow letter, number, underscore, and hyphen'
    )
    assert_selector '.invalid-feedback', text: "Reference token can't be blank"
    assert_selector '.invalid-feedback', text: "Title can't be blank"

    logout :admin
  end

  test 'creating a Tender Notice' do
    login_as @confirmed_board_admin, scope: :admin

    visit new_tms_notice_url

    within('form.tms-notice__form') do
      fill_in 'notice_reference_token', with: 'abc-98-xy_z'
      fill_in 'notice_title', with: 'title'
      fill_in 'notice_description', with: 'description'
      fill_in 'notice_specification', with: 'specification'
      fill_in 'notice_terms_and_conditions', with: 'terms and conditions'
      execute_script(
        "document.getElementById('notice_opening_on_string').value = '#{(DateTime.now + 2.days).to_s(:db)}'"
      )
      execute_script(
        "document.getElementById('notice_closing_on_string').value = '#{(DateTime.now + 5.days).to_s(:db)}'"
      )

      click_on 'Create Tender notice'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Tender Notice was successfully created.'
    end

    assert_selector '.tms-notice__content'

    logout :admin
  end

  test 'updating a tender notice' do
    login_as @confirmed_board_admin, scope: :admin

    visit edit_tms_notice_url(@draft_tender_notice)

    within('form.tms-notice__form') do
      fill_in 'notice_title', with: 'new title for the tender notice'
      click_on 'Update Tender notice'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Tender Notice was successfully updated.'
    end

    within('.tms-notice__content') do
      assert_text 'new title for the tender notice'
    end

    logout :admin
  end

  test 'destroying a tender notice' do
    login_as @confirmed_board_admin, scope: :admin

    visit draft_tms_notices_url

    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Tender Notice was successfully destroyed.'
    end

    logout :admin
  end

  test 'sub-menus of notices dashboard' do
    login_as @confirmed_board_admin, scope: :admin

    visit management_dashboard_url

    click_on 'Tender Notices'

    within('#collapse-tender-notices') do
      click_on 'Draft'
    end

    within('table.tms-notices__table') do
      assert_selector '.tms-notices__table-row', count: 2
      assert_selector 'td', text: 'boom barriers for the society gates'
    end

    within('#collapse-tender-notices') do
      click_on 'Upcoming'
    end

    within('table.tms-notices__table') do
      assert_selector '.tms-notices__table-row', count: 1
      assert_selector 'td', text: 'supply air quality monitors'
    end

    within('#collapse-tender-notices') do
      click_on 'Current'
    end

    within('table.tms-notices__table') do
      assert_selector '.tms-notices__table-row', count: 1
      assert_selector 'td', text: 'Barb wire for fencing'
    end

    within('#collapse-tender-notices') do
      click_on 'Under Review'
    end

    within('table.tms-notices__table') do
      assert_selector '.tms-notices__table-row', count: 1
      assert_selector 'td', text: 'Installation for water purifier for each tower'
    end

    within('#collapse-tender-notices') do
      click_on 'Archived'
    end

    within('table.tms-notices__table') do
      assert_selector '.tms-notices__table-row', count: 1
      assert_selector 'td', text: 'Replacement of elevator buttons'
    end

    logout :admin
  end

  test 'set errors if validations are not passed - missing attachement' do
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@draft_tender_notice)

    within('form.button_to') do
      click_on 'Publish'
    end

    within('#error_explanation') do
      assert_selector '.invalid-feedback',
                      text: 'Document attachment is required for publishing the notice'
    end

    logout :admin
  end

  test 'set errors if validations are not passed - missing opening_on' do
    @draft_tender_notice.opening_on = nil
    @draft_tender_notice.save

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@draft_tender_notice)

    within('form.button_to') do
      click_on 'Publish'
    end

    within('#error_explanation') do
      assert_selector '.invalid-feedback',
                      text: 'Opening on is required for publishing the notice'
    end

    logout :admin
  end

  test 'set errors if validations are not passed - missing closing_on' do
    @draft_tender_notice.closing_on = nil
    @draft_tender_notice.save

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@draft_tender_notice)

    within('form.button_to') do
      click_on 'Publish'
    end

    within('#error_explanation') do
      assert_selector '.invalid-feedback',
                      text: 'Closing on is required for publishing the notice'
    end

    logout :admin
  end

  test 'set errors if timeframe is invalid' do
    @draft_tender_notice.opening_on = DateTime.current + 10.days
    @draft_tender_notice.save

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@draft_tender_notice)

    within('form.button_to') do
      click_on 'Publish'
    end

    within('#error_explanation') do
      assert_selector '.invalid-feedback',
                      text: 'Opening on should be before closing on'
    end

    logout :admin
  end

  test 'set error if current date is after opening_on of the tender notice' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )
    @draft_tender_notice.opening_on = DateTime.current - 5.days
    @draft_tender_notice.save

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@draft_tender_notice)

    within('form.button_to') do
      click_on 'Publish'
    end

    within('#error_explanation') do
      assert_selector '.invalid-feedback',
                      text: 'Opening on should be after current date and time'
    end

    logout :admin
  end

  test 'publishing a draft tender notice' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )
    @draft_tender_notice.save

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@draft_tender_notice)

    within('form.button_to') do
      click_on 'Publish'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body',
                      text: 'Tender Notice was successfully published.'
    end

    logout :admin
  end

  test 'that publish button is not visible to staff' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )
    @draft_tender_notice.save

    login_as @confirmed_staff_admin, scope: :admin

    visit tms_notice_url(@draft_tender_notice)

    assert_no_selector '.tender_notice__control'

    logout :admin
  end

  test 'that publish button is not visible for published tender notice' do
    attach_file_to_record(
      @published_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )
    @published_tender_notice.save

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@published_tender_notice)

    assert_no_selector '.tender_notice__control'

    logout :admin
  end

  test 'that proposals will be shown for under_review tender notices' do
    @under_review_tender_notice.proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@under_review_tender_notice)

    within('.tms-notice-proposals') do
      assert_selector 'tr.tms-notice-proposal', count: 3
    end

    logout :admin
  end

  test 'that proposals will be shown for archived tender notices' do
    @archived_tender_notice.proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@archived_tender_notice)

    within('.tms-notice-proposals') do
      assert_selector 'tr.tms-notice-proposal', count: 1
    end

    logout :admin
  end

  test 'that proposals will not be shown for current tender notices' do
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@current_tender_notice)

    assert_no_selector '.tms-notice-proposals'

    logout :admin
  end

  test 'show errors in proposal selection form when it is not filled' do
    @under_review_tender_notice.proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@under_review_tender_notice)

    within('form.tms-proposal-selction__form') do
      click_on "Select Vendor's Proposal"
    end

    assert_selector '.invalid-feedback', text: "Selection reason can't be blank"
    assert_selector '.invalid-feedback',
                    text: 'Email is not found in proposals submitted for the tender notice'

    logout :admin
  end

  test 'successful proposal selection' do
    @under_review_tender_notice.proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@under_review_tender_notice)

    select @under_review_tender_notice.proposals.first.email,
           from: 'proposal_selection_form[token]'
    fill_in 'proposal_selection_form_selection_reason', with: 'good offering'
    click_on "Select Vendor's Proposal"

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Proposal selected successfully.'
    end
    within('.tms-proposal') do
      assert_text 'good offering'
    end
    assert_selector 'a.list-group-item', text: 'Archived'

    logout :admin
  end

  test 'that proposal selection form is not visible to staff admin' do
    @under_review_tender_notice.proposals.each do |proposal|
      attach_file_to_record(proposal.document.attachment, 'sheet.xlsx')
    end
    login_as @confirmed_staff_admin, scope: :admin

    visit tms_notice_url(@under_review_tender_notice)

    assert_no_selector '.tms-proposal-selction'

    logout :admin
  end
end
