require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @finished_post = posts(:lotus)
  end

  teardown do
    @finished_post = nil
  end

  test 'should get index' do
    get posts_url
    assert_response :success
  end

  test 'should get show' do
    get post_url(@finished_post)
    assert_response :success
  end
end
