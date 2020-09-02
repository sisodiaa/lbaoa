require 'test_helper'

class PostTagsFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @confirmed_staff_admin = admins(:confirmed_staff_admin)

    @draft_post = posts(:plantation)
    @finished_post = posts(:lotus)

    @category = categories(:horticulture)
  end

  teardown do
    @confirmed_board_admin = @confirmed_staff_admin = nil
    @draft_post = @finished_post = @category = nil
  end

  test 'creating a post' do
    sign_in @confirmed_board_admin, scope: :admin

    assert_difference('Post.count') do
      assert_difference('Tag.count', 2) do
        assert_difference('Tagging.count', 2) do
          post cms_posts_url, params: {
            post: {
              category_id: @category.id,
              title: 'New title of a new post',
              content: '<h1><em>Rich text</em> using HTML</h1>',
              tag_list: 'new , draft post '
            }
          }
        end
      end
    end

    assert_redirected_to cms_post_url(Post.last)

    sign_out :admin
  end

  test 'deleting a post' do
    sign_in @confirmed_board_admin, scope: :admin

    assert_difference('Post.count', -1) do
      assert_difference('Tag.count', 0) do
        assert_difference('Tagging.count', -2) do
          delete cms_post_url(@draft_post)
        end
      end
    end

    assert_redirected_to cms_posts_url

    sign_out :admin
  end
end
