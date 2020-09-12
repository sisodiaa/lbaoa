require 'test_helper'

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @draft_post = posts(:plantation)
    @published_tender_notice = tender_notices(:air_quality_monitors)
    @draft_tender_notice = tender_notices(:boom_barriers)
    @excel_document = documents(:excel)
  end

  teardown do
    @excel_document = nil
    @draft_tender_notice = nil
    @draft_post = nil
    @confirmed_board_admin = nil
  end

  test 'unauthenticated access should redirect' do
    get post_documents_url(@draft_post)
    assert_redirected_to new_admin_session_url
  end

  test 'should get index' do
    sign_in @confirmed_board_admin, scope: :admin

    @draft_post.documents.each do |document|
      attach_file_to_record(document.attachment, 'square.png')
    end

    get post_documents_url(@draft_post)
    assert_response :success

    sign_out :admin
  end

  test 'should not create document without attachment' do
    sign_in @confirmed_board_admin, scope: :admin

    @draft_post.documents.each do |document|
      attach_file_to_record(document.attachment, 'square.png')
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

  test 'should create document for a Post' do
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

  test 'should create document for a Tender Notice' do
    sign_in @confirmed_board_admin, scope: :admin

    assert_difference('Document.count') do
      post tender_notice_document_url(@draft_tender_notice), params: {
        document: {
          attachment: fixture_file_upload(
            'files/tender_notice.xlsx',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
          ),
          annotation: 'Tender Notice'
        }
      }
    end

    assert @draft_tender_notice.document.attachment.attached?
    assert_equal ActiveStorage::Attachment.count, 1
    assert_redirected_to tender_notice_document_url(@draft_tender_notice)

    sign_out :admin
  end

  test 'that creating a new document for a tender notice replaces the old one' do
    sign_in @confirmed_board_admin, scope: :admin

    attach_file_to_record(@excel_document.attachment, 'tender_notice.xlsx')
    assert @published_tender_notice.document.attachment.attached?
    assert_equal 'tender_notice.xlsx',
                 @published_tender_notice.document.attachment.filename.to_s

    assert_difference('Document.count', 0) do
      post tender_notice_document_url(@published_tender_notice), params: {
        document: {
          attachment: fixture_file_upload(
            'files/tap_tender.xls', 'application/vnd.ms-excel'
          ),
          annotation: 'New Tender Notice'
        }
      }
    end

    assert @published_tender_notice.reload.document.attachment.attached?
    assert_equal 'tap_tender.xls',
                 @published_tender_notice.reload.document.attachment.filename.to_s
    assert_equal ActiveStorage::Attachment.count, 1
    assert_redirected_to tender_notice_document_url(@published_tender_notice)

    sign_out :admin
  end

  test 'should not create document for large files' do
    sign_in @confirmed_board_admin, scope: :admin

    @draft_post.documents.each do |document|
      attach_file_to_record(document.attachment, 'square.png')
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

  test 'should destroy a document - Post' do
    sign_in @confirmed_board_admin, scope: :admin

    assert_difference('Document.count', -1) do
      delete post_document_url(@draft_post, documents(:image))
    end

    assert_redirected_to post_documents_url(@draft_post)

    sign_out :admin
  end

  test 'should destroy a document - Tender Notice' do
    sign_in @confirmed_board_admin, scope: :admin

    assert_difference('Document.count', -1) do
      delete tender_notice_document_url(@published_tender_notice)
    end

    assert_redirected_to tender_notice_document_url(@published_tender_notice)

    sign_out :admin
  end
end
