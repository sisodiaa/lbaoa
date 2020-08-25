require 'test_helper'

module CMS
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @confirmed_staff_admin = admins(:confirmed_staff_admin)

      @draft_post = posts(:plantation)
      @finished_post = posts(:lotus)
      @public_post = posts(:nursery)

      @category = categories(:horticulture)
    end

    teardown do
      @confirmed_board_admin = @confirmed_staff_admin = nil
      @draft_post = @finished_post = @public_post = nil
      @category = nil
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
            category_id: @category.id,
            title: 'New title of a new post',
            content: '<h1><em>Rich text</em> using HTML</h1>',
            tag_list: 'new, draft post'
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

    test 'board member can delete draft post' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      assert_difference('Post.count', -1) do
        delete cms_post_url(@draft_post)
      end

      assert_redirected_to cms_posts_url

      sign_out :cms_admin
    end

    test 'board member can delete published post' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      assert_difference('Post.count', -1) do
        delete cms_post_url(@finished_post)
      end

      assert_redirected_to cms_posts_url

      sign_out :cms_admin
    end

    test 'braodcast a member only post to visitors' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      assert @finished_post.members?
      assert_not @finished_post.visitors?

      patch cast_cms_post_path(@finished_post), params: {
        post: {
          visibility_state: :visitors
        }
      }

      assert_not @finished_post.reload.members?
      assert @finished_post.visitors?

      assert_redirected_to cms_post_url(@finished_post)
      assert_equal 'Post visibility status set for visitors.', flash[:success]

      sign_out :cms_admin
    end

    test 'narrowcast a public post to members only' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      assert @public_post.visitors?
      assert_not @public_post.members?

      patch cast_cms_post_path(@public_post), params: {
        post: {
          visibility_state: :members
        }
      }

      assert_not @public_post.reload.visitors?
      assert @public_post.members?

      assert_redirected_to cms_post_url(@public_post)
      assert_equal 'Post visibility status set for members only.', flash[:success]

      sign_out :cms_admin
    end

    test 'publish a post' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      assert @draft_post.draft?
      assert_not @draft_post.finished?
      assert_nil @draft_post.published_at

      patch publish_cms_post_path(@draft_post), params: {
        post: {
          publication_state: :finished
        }
      }

      assert_not @draft_post.reload.draft?
      assert @draft_post.finished?
      assert_not_nil @draft_post.published_at

      assert_redirected_to post_url(@draft_post)
      assert_equal 'Post published successfully.', flash[:success]

      sign_out :cms_admin
    end

    test 'staff member can not publish a post' do
      sign_in @confirmed_staff_admin, scope: :cms_admin

      patch publish_cms_post_path(@draft_post), params: {
        post: {
          publication_state: :finished
        }
      }

      assert_equal 'Only board member can publish a post.', flash[:error]
      assert_redirected_to cms_root_url

      sign_out :cms_admin
    end

    test 'staff member can not delete a published post' do
      sign_in @confirmed_staff_admin, scope: :cms_admin

      assert_difference('Post.count', 0) do
        delete cms_post_url(@finished_post)
      end

      assert_equal 'Only board member can delete a post.', flash[:error]
      assert_redirected_to cms_root_url

      sign_out :cms_admin
    end

    test 'staff member can delete a draft post' do
      sign_in @confirmed_staff_admin, scope: :cms_admin

      assert_difference('Post.count', -1) do
        delete cms_post_url(@draft_post)
      end

      assert_redirected_to cms_posts_url

      sign_out :cms_admin
    end
  end
end
