require 'test_helper'

module Search
  class PostsControllerTest < ActionDispatch::IntegrationTest
    test 'should get index' do
      get search_posts_url(category: 'helpdesk')

      assert_response :success
    end
  end
end
