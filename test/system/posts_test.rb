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

    select 'Horticulture', from: 'post[department_id]'
    fill_in 'Title', with: 'Do not pluck flowers'

    content = 'Be a responsible resident, and care for flowers & trees.'
    find(:xpath, "//trix-editor[@id='post_content']").set(content)

    click_on 'Create Post'

    assert_text 'Post was successfully created'
    click_on 'Back'
  end

  test 'creating a Post with insufficient data shows validation errors' do
    visit cms_posts_url
    click_on 'New Post'

    click_on 'Create Post'

    assert_selector '.is-invalid', count: 3
    assert_selector '.invalid-feedback', count: 3
    assert_selector '.invalid-feedback', text: "Title can't be blank"
    assert_selector '.invalid-feedback', text: "Content can't be blank"
  end

  test 'updating a Post' do
    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

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

  test 'shows a post' do
    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    visit cms_post_url(@draft_post)

    within('.post__title') do
      assert_selector 'h1', text: @draft_post.title
      assert_text "Published: #{@draft_post.created_at.strftime('%d %B %Y')}"
    end

    within('.post__attachments') do
      assert_selector '.podlet', count: @draft_post.documents.count
    end
  end
end
