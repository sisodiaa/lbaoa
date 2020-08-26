require 'test_helper'

module Search
  class PostsControllerTest < ActionDispatch::IntegrationTest
    test 'visitors can not access search' do
      get search_posts_url

      assert_redirected_to new_member_session_path
    end

    test 'only members should get index' do
      sign_in members(:confirmed_member)

      get search_posts_url(category: 'helpdesk')

      assert_response :success

      sign_out :member
    end
  end
end
