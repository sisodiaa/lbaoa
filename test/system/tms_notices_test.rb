require 'application_system_test_case'

class TMSNoticesTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @draft_tender_notice = tender_notices(:boom_barriers)
    @published_tender_notice = tender_notices(:air_quality_monitors)
    @excel_document = documents(:excel)
  end

  teardown do
    @excel_document = nil
    @published_tender_notice = nil
    @draft_tender_notice = nil
    @confirmed_board_admin = nil
    Warden.test_reset!
  end

  test 'index all tender notices' do
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notices_url

    sleep 5
    assert_selector '.tender-notices__table-row', count: TenderNotice.count

    logout :admin
  end

  test 'published tender notice have a download link for the attachment' do
    attach_file_to_record(@excel_document.attachment, 'tender_notice.xlsx')

    login_as @confirmed_board_admin, scope: :admin

    visit tms_notice_url(@published_tender_notice)

    assert_selector "a[href$='tender_notice.xlsx?disposition=attachment']"
    sleep 3

    logout :admin
  end

  test 'creating a Tender Notice with insufficient data shows validation errors' do
    login_as @confirmed_board_admin, scope: :admin

    visit admin_root_url

    within(:xpath, "//div[@id='navbarCMS']") do
      find(:xpath, "//a[@id='dashboard-new-dropdown']").click
      find(:xpath, "//a[@class='dropdown-item'][3]").click
    end

    within('.tender-notice__form') do
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

    within('form.tender-notice__form') do
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

    assert_selector '.tender-notice__content'

    logout :admin
  end

  test 'updating a tender notice' do
    login_as @confirmed_board_admin, scope: :admin

    visit edit_tms_notice_url(@draft_tender_notice)

    within('form.tender-notice__form') do
      fill_in 'notice_title', with: 'new title for the tender notice'
      click_on 'Update Tender notice'
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Tender Notice was successfully updated.'
    end

    within('.tender-notice__content') do
      assert_text 'new title for the tender notice'
    end

    logout :admin
  end

  test 'destroying a tender notice' do
    login_as @confirmed_board_admin, scope: :admin

    visit tms_notices_url

    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Tender Notice was successfully destroyed.'
    end

    logout :admin
  end
end
