require 'application_system_test_case'

class DocumentsTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @draft_post = posts(:plantation)
    @published_tender_notice = tender_notices(:air_quality_monitors)
    @draft_tender_notice = tender_notices(:boom_barriers)
    @draft_tender_notice_with_attachment = tender_notices(:cctv_cables)
    @excel_document = documents(:excel)
    @xls_document = documents(:xls)
  end

  teardown do
    @excel_document = @xls_document = nil
    @draft_tender_notice_with_attachment = nil
    @published_tender_notice = @draft_tender_notice = nil
    @draft_post = nil

    @confirmed_board_admin = nil
    Warden.test_reset!
  end

  test 'visiting the index - Post' do
    visit_document_form_for_post

    assert_selector 'form'
    assert_selector '.podlet', count: 2

    logout :admin
  end

  test 'visiting the show - Tender Notice with document' do
    visit_document_form_for_tender_notice_with_document

    assert_selector '.podlet', count: 1

    logout :admin
  end

  test 'visiting the show - Tender Notice without document' do
    visit_document_form_for_tender_notice_without_document

    assert_selector 'form'

    logout :admin
  end

  test 'showing validation errors on incomplete or wrong input - Post' do
    visit_document_form_for_post

    fill_in 'document_annotation', with: 'a' * 55
    click_on 'Create Attachment'

    assert_selector '.is-invalid', count: 2
    assert_selector '.invalid-feedback',
                    text: 'Annotation is too long (maximum is 50 characters)'
    assert_selector '.invalid-feedback', text: "Attachment can't be absent"

    logout :admin
  end

  test 'showing validation errors on incomplete or wrong input - Tender Notice' do
    visit_document_form_for_tender_notice_without_document

    fill_in 'document_annotation', with: 'a' * 55
    click_on 'Create Attachment'

    assert_selector '.is-invalid', count: 2
    assert_selector '.invalid-feedback',
                    text: 'Annotation is too long (maximum is 50 characters)'
    assert_selector '.invalid-feedback', text: "Attachment can't be absent"

    logout :admin
  end

  test 'attach a file to a document using form - Post' do
    visit_document_form_for_post

    fill_in 'document_annotation', with: 'Cheatsheet for vim'
    attach_file 'document_attachment',
                Rails.root.join('test/fixtures/files/vim-cheatsheet.pdf'),
                visible: false
    click_on 'Create Attachment'

    assert_selector 'a img', count: 3

    logout :admin
  end

  test 'attach a file to a document using form - Tender Notice' do
    visit_document_form_for_tender_notice_without_document

    fill_in 'document_annotation', with: 'Tender for Taps'
    attach_file 'document_attachment',
                Rails.root.join('test/fixtures/files/tap_tender.xls'),
                visible: false
    click_on 'Create Attachment'

    assert_selector 'small', text: 'Preview generation not supported for this format.'

    logout :admin
  end

  test 'delete an attachment - Post' do
    visit_document_form_for_post

    assert_selector 'a img', count: 2

    page.accept_confirm do
      click_on 'Delete Attachment', match: :first
    end

    assert_selector 'a img', count: 1

    logout :admin
  end

  test 'delete an attachment - Tender Notice' do
    attach_file_to_record(@xls_document.attachment, 'tap_tender.xls')

    login_as @confirmed_board_admin, scope: :admin

    visit tender_notice_document_url(@draft_tender_notice_with_attachment)

    assert_selector 'small', text: 'Preview generation not supported for this format.'

    page.accept_confirm do
      click_on 'Delete Attachment', match: :first
    end

    assert_selector 'form'

    logout :admin
  end

  test 'that clicking on thumbnail will open a new window - Post' do
    visit_document_form_for_post

    new_window = window_opened_by { first('.podlet img.img-fluid').click }
    within_window new_window do
      assert_match(/square.png$/, current_url)
      assert_match(/square.png$/, first('img')['src'])
    end

    logout :admin
  end

  test 'that downloadable links exists - Post' do
    visit_document_form_for_post

    assert_selector "a[href$='square.png?disposition=attachment']", count: 2

    logout :admin
  end

  test 'that downloadable links exists - Tender Notice' do
    visit_document_form_for_tender_notice_with_document

    assert_selector "a[href$='tender_notice.xlsx?disposition=attachment']"

    logout :admin
  end

  private

  def visit_document_form_for_post
    @draft_post.documents.each do |document|
      attach_file_to_record(document.attachment, 'square.png')
    end

    login_as @confirmed_board_admin, scope: :admin

    visit post_documents_url(@draft_post)
  end

  def visit_document_form_for_tender_notice_with_document
    attach_file_to_record(@excel_document.attachment, 'tender_notice.xlsx')

    login_as @confirmed_board_admin, scope: :admin

    visit tender_notice_document_url(@published_tender_notice)
  end

  def visit_document_form_for_tender_notice_without_document
    login_as @confirmed_board_admin, scope: :admin

    visit tender_notice_document_url(@draft_tender_notice)
  end
end
