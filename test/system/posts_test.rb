require 'application_system_test_case'

class PostsTest < ApplicationSystemTestCase
  setup do
    @draft_post = posts(:plantation)
    @finished_post = posts(:lotus)
  end

  teardown do
    @draft_post = @finished_post = nil
  end

  test 'visiting the index' do
    visit cms_posts_url

    within('#posts__draft') do
      assert_text 'Draft Posts'

      within('tbody') do
        assert_selector 'tr', count: 1
      end
    end

    within('#posts__published') do
      assert_text 'Published Posts'

      within('tbody') do
        assert_selector 'tr', count: 2
      end
    end
  end

  test 'creating a Post' do
    visit cms_posts_url
    click_on 'New Post'

    select 'Horticulture', from: 'post[department_id]'
    fill_in 'Title', with: 'Do not pluck flowers'

    content = 'Be a responsible resident, and care for flowers & trees.'
    find(:xpath, "//trix-editor[@id='post_content']").set(content)

    click_on 'Create Post'

    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Post was successfully created.'
    end
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

    assert_text 'Edited title for system test'

    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Post was successfully updated.'
    end
    click_on 'Back'
  end

  test 'destroying a Post' do
    visit cms_posts_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Post was successfully destroyed.'
    end
  end

  test 'shows a post' do
    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    visit cms_post_url(@draft_post)

    within('.post__header') do
      assert_selector 'h1', text: @draft_post.title
      assert_text "Created: #{@draft_post.created_at.strftime('%d %B %Y')}"
    end

    assert_no_selector '.post__attachments'

    within('.post__controls.pod') do
      find('.btn', text: /^Show/).click
    end

    within('.post__attachments') do
      assert_selector '.podlet', count: @draft_post.documents.count
    end

    within('.post__controls.pod') do
      find('.btn', text: /^Hide/).click
    end

    assert_no_selector '.post__attachments'
  end

  test 'edit controls are not shown for a finished post' do
    @finished_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    visit cms_post_url(@finished_post)

    within('.post__controls.pod') do
      assert_no_selector '.btn.btn-outline-primary', text: 'Edit'
    end
  end

  test 'publishing a draft post' do
    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    visit cms_post_url(@draft_post)

    click_on 'Publish'

    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Post published successfully.'
    end
  end

  test 'lists all finished posts' do
    visit posts_url

    assert_selector 'h3.post__title', count: 2
  end
end
