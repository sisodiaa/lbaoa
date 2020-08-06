require 'test_helper'

module CMS
  class PagesControllerTest < ActionDispatch::IntegrationTest
    test 'that a valid request respond successfully' do
      get page_url('lbaoa')
      assert_response :success
    end

    test 'that a request is unsuccessfull if there no page with given name' do
      get page_url('not-exist')
      assert_response :not_found
    end

    test '#send_public_document - success' do
      get public_document_url(
        filename: 'lb_aoa_certified_bye_laws_and_registration_certificate.pdf'
      )

      assert_response :success
      assert_equal 'application/pdf', response.content_type
    end

    test '#send_public_document - invalid file' do
      get public_document_url(
        filename: 'unknown.pdf'
      )

      assert_equal 'text/html; charset=utf-8', response.content_type
      assert_redirected_to root_url
    end
  end
end
