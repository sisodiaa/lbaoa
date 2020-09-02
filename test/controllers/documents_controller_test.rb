require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @draft_post = posts(:plantation)
  end

  teardown do
    @confirmed_board_admin = @draft_post = nil
  end

  test 'unauthenticated access should redirect' do
    get post_documents_url(@draft_post)
    assert_redirected_to new_admin_session_url
  end

  test 'should get index' do
    sign_in @confirmed_board_admin, scope: :admin

    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    get post_documents_url(@draft_post)
    assert_response :success

    sign_out :admin
  end

  test 'should not create document without attachment' do
    sign_in @confirmed_board_admin, scope: :admin

    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    assert_difference('Document.count', 0) do
      post post_documents_url(@draft_post), params: {
        document: {
          annotation: 'Portrait'
        }
      }
    end

    sign_out :admin
  end

  test 'should create document' do
    sign_in @confirmed_board_admin, scope: :admin

    assert_difference('Document.count') do
      post post_documents_url(@draft_post), params: {
        document: {
          attachment: fixture_file_upload('files/portrait.png', 'image/png'),
          annotation: 'Portrait'
        }
      }
    end

    assert @draft_post.documents.last.attachment.attached?
    assert_equal ActiveStorage::Attachment.count, 1
    assert_redirected_to post_documents_url(@draft_post)

    sign_out :admin
  end

  test 'should not create document for large files' do
    sign_in @confirmed_board_admin, scope: :admin

    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    assert_equal ActiveStorage::Attachment.count, 2

    assert_difference('Document.count', 0) do
      post post_documents_url(@draft_post), params: {
        document: {
          attachment: fixture_file_upload(
            'files/flower-hq.jpg',
            'image/jpeg'
          ),
          annotation: 'Portrait'
        }
      }
    end

    assert_equal ActiveStorage::Attachment.count, 2

    sign_out :admin
  end

  test 'should destroy a document' do
    sign_in @confirmed_board_admin, scope: :admin

    assert_difference('Document.count', -1) do
      delete post_document_url(@draft_post, documents(:image))
    end

    assert_redirected_to post_documents_url(@draft_post)

    sign_out :admin
  end
end
