require 'application_system_test_case'

class PostsTest < ApplicationSystemTestCase
  setup do
    @draft_post = posts(:plantation)
  end

  teardown do
    @draft_post = nil
  end

  test 'visiting the index' do
    skip
    visit posts_url
    assert_selector 'h1', text: 'Posts'
  end

  test 'creating a Post' do
    visit cms_posts_url
    click_on 'New Post'

    fill_in 'Title', with: 'Do not pluck flowers'
    select 'Horticulture', from: 'post[department_id]'
    click_on 'Create Post'

    assert_text 'Post was successfully created'
    click_on 'Back'
  end

  test 'updating a Post' do
    visit cms_posts_url
    click_on 'Edit', match: :first

    fill_in 'Title', with: 'Edited title for system test'
    click_on 'Update Post'

    assert_text 'Post was successfully updated'
    assert_text 'Edited title for system test'
    click_on 'Back'
  end

  test 'destroying a Post' do
    visit cms_posts_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Post was successfully destroyed'
  end
end
