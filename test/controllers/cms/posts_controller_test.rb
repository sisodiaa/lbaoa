require 'test_helper'

module CMS
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @draft_post = posts(:plantation)
      @department = departments(:horticulture)
    end

    teardown do
      @draft_post = @department = nil
    end

    test 'should get index' do
      get cms_posts_url
      assert_response :success
    end

    test 'should get new' do
      get new_cms_post_url
      assert_response :success
    end

    test 'should create post' do
      assert_difference('Post.count') do
        post cms_posts_url, params: {
          post: {
            department_id: @department.id,
            title: 'New title of a new post',
            content: '<h1><em>Rich text</em> using HTML</h1>'
          }
        }
      end

      assert_redirected_to cms_post_url(Post.last)
    end

    test 'should show post' do
      @draft_post.documents.each do |document|
        attach_file_to_record document.attachment
      end

      get cms_post_url(@draft_post)
      assert_response :success
    end

    test 'should get edit' do
      get edit_cms_post_url(@draft_post)
      assert_response :success
    end

    test 'should update post' do
      patch cms_post_url(@draft_post), params: {
        post: {
          title: 'Updating the title of the post'
        }
      }

      assert_redirected_to cms_post_url(@draft_post)
    end

    test 'should destroy post' do
      assert_difference('Post.count', -1) do
        delete cms_post_url(@draft_post)
      end

      assert_redirected_to cms_posts_url
    end
  end
end
