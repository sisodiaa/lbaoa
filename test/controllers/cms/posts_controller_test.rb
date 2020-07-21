require 'test_helper'

module CMS
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @draft_post = posts(:plantation)
      @finished_post = posts(:lotus)
      @department = departments(:horticulture)
    end

    teardown do
      @confirmed_board_admin = @draft_post = @finished_post = @department = nil
    end

    test 'unauthenticated access should redirect' do
      get cms_posts_url
      assert_redirected_to new_cms_admin_session_url
    end

    test 'should get index' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      get cms_posts_url
      assert_response :success

      sign_out :cms_admin
    end

    test 'should get new' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      get new_cms_post_url
      assert_response :success

      sign_out :cms_admin
    end

    test 'should create post' do
      sign_in @confirmed_board_admin, scope: :cms_admin

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

      sign_out :cms_admin
    end

    test 'should show post' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      @draft_post.documents.each do |document|
        attach_file_to_record document.attachment
      end

      get cms_post_url(@draft_post)
      assert_response :success

      sign_out :cms_admin
    end

    test 'should get edit' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      get edit_cms_post_url(@draft_post)
      assert_response :success

      sign_out :cms_admin
    end

    test 'should update post' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      patch cms_post_url(@draft_post), params: {
        post: {
          title: 'Updating the title of the post'
        }
      }

      assert_redirected_to cms_post_url(@draft_post)

      sign_out :cms_admin
    end

    test 'should destroy post' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      assert_difference('Post.count', -1) do
        delete cms_post_url(@draft_post)
      end

      assert_redirected_to cms_posts_url

      sign_out :cms_admin
    end

    test 'publish a post' do
      sign_in @confirmed_board_admin, scope: :cms_admin

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
      assert_equal 'Post published successfully.', flash[:success]

      sign_out :cms_admin
    end

    test 'staff member can not publish a post' do
      sign_in admins(:confirmed_staff_admin), scope: :cms_admin

      patch publish_cms_post_path(@draft_post), params: {
        post: {
          publication_state: :finished
        }
      }

      assert_equal 'Only board member can publish a post.', flash[:error]
      assert_redirected_to cms_root_url

      sign_out :cms_admin
    end
  end
end
