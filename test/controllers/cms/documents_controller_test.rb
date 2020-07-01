require 'test_helper'

module CMS
  class DocumentsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @draft_post = posts(:plantation)
    end

    teardown do
      @draft_post = nil
    end

    test 'should get index' do
      @draft_post.documents.each do |document|
        attach_file_to_record document.attachment
      end

      get cms_post_documents_url(@draft_post)
      assert_response :success
    end

    test 'should not create document without attachment' do
      @draft_post.documents.each do |document|
        attach_file_to_record document.attachment
      end

      assert_difference('Document.count', 0) do
        post cms_post_documents_url(@draft_post), params: {
          document: {
            annotation: 'Portrait'
          }
        }
      end
    end

    test 'should create document' do
      assert_difference('Document.count') do
        post cms_post_documents_url(@draft_post), params: {
          document: {
            attachment: fixture_file_upload('files/portrait.png', 'image/png'),
            annotation: 'Portrait'
          }
        }
      end

      assert @draft_post.documents.last.attachment.attached?
      assert_equal ActiveStorage::Attachment.count, 1
      assert_redirected_to cms_post_documents_url(@draft_post)
    end

    test 'should not create document for large files' do
      @draft_post.documents.each do |document|
        attach_file_to_record document.attachment
      end

      assert_equal ActiveStorage::Attachment.count, 2

      assert_difference('Document.count', 0) do
        post cms_post_documents_url(@draft_post), params: {
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
    end

    test 'should destroy a document' do
      assert_difference('Document.count', -1) do
        delete cms_post_document_url(@draft_post, documents(:image))
      end

      assert_redirected_to cms_post_documents_url(@draft_post)
    end
  end
end
