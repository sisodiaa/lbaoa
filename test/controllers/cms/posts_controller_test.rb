require 'test_helper'

module CMS
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @draft_post = posts(:plantation)
      @finished_post = posts(:lotus)
      @department = departments(:horticulture)
    end

    teardown do
      @draft_post = @finished_post = @department = nil
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

    test 'should not update finished post' do
      patch cms_post_url(@finished_post), params: {
        post: {
          title: 'Updating the title of the post'
        }
      }

      assert_redirected_to cms_post_url(@finished_post)
      assert_equal 'This operation is not allowed on finished post',
                   flash[:notice]
    end

    test 'should not destroy finished post' do
      assert_difference('Post.count', 0) do
        delete cms_post_url(@finished_post)
      end

      assert_redirected_to cms_post_url(@finished_post)
      assert_equal 'This operation is not allowed on finished post',
                   flash[:notice]
    end

    test 'publish a post' do
      assert @draft_post.draft?
      assert_not @draft_post.finished?

      patch publish_cms_post_path(@draft_post), params: {
        post: {
          publication_state: :finished
        }
      }

      assert_not @draft_post.reload.draft?
      assert @draft_post.reload.finished?

      assert_redirected_to post_url(@draft_post)
      assert_equal 'Post published successfully.', flash[:notice]
    end
  end
end
