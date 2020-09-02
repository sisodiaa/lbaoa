require 'application_system_test_case'

class DocumentsTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @draft_post = posts(:plantation)

    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    login_as @confirmed_board_admin, scope: :admin

    visit post_documents_url(@draft_post)
  end

  teardown do
    logout :admin

    @draft_post = nil

    @confirmed_board_admin = nil
    Warden.test_reset!
  end

  test 'visiting the index' do
    assert_selector 'form'
    assert_selector '.podlet', count: 2
  end

  test 'showing validation errors on incomplete or wrong input' do
    fill_in 'document_annotation', with: 'a' * 55
    click_on 'Create Attachment'

    assert_selector '.is-invalid', count: 2
    assert_selector '.invalid-feedback',
                    text: 'Annotation is too long (maximum is 50 characters)'
    assert_selector '.invalid-feedback', text: "Attachment can't be absent"
  end

  test 'attach a file to a document using form' do
    fill_in 'document_annotation', with: 'Cheatsheet for vim'
    attach_file 'document_attachment',
                Rails.root.join('test/fixtures/files/vim-cheatsheet.pdf'),
                visible: false
    click_on 'Create Attachment'

    assert_selector 'a img', count: 3
  end

  test 'delete an attachment' do
    assert_selector 'a img', count: 2

    page.accept_confirm do
      click_on 'Delete Attachment', match: :first
    end

    assert_selector 'a img', count: 1
  end

  test 'that clicking on thumbnail will open a new window' do
    new_window = window_opened_by { first('.podlet img.img-fluid').click }
    within_window new_window do
      assert_match(/square.png$/, current_url)
      assert_match(/square.png$/, first('img')['src'])
    end
  end

  test 'that downloadable links exists' do
    assert_selector "a[href$='square.png?disposition=attachment']", count: 2
  end
end
