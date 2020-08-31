require 'test_helper'

module Search
  class MembersControllerTest < ActionDispatch::IntegrationTest
    test 'unauthorized access to search is not allowed' do
      sign_in members(:confirmed_member), scope: :member

      get search_members_url

      assert_redirected_to new_cms_admin_session_url

      sign_out :member
    end

    test 'only admins can access search' do
      sign_in admins(:confirmed_board_admin), scope: :cms_admin

      get search_members_url

      assert_response :success

      sign_out :cms_admin
    end
  end
end
