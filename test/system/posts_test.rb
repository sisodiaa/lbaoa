require 'application_system_test_case'

class PostsTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @confirmed_staff_admin = admins(:confirmed_staff_admin)

    @draft_post = posts(:plantation)
    @finished_post = posts(:lotus)
  end

  teardown do
    @draft_post = @finished_post = nil

    @confirmed_board_admin = @confirmed_staff_admin = nil
    Warden.test_reset!
  end

  test 'visiting the index' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_posts_url

    within('.list-group.show') do
      assert_selector '.list-group-item.active', text: 'Drafts'
    end

    within('.posts__table') do
      within('tbody') do
        assert_selector 'tr', count: 10
      end
    end

    find('.page-item.next a').click

    within('.posts__table') do
      within('tbody') do
        assert_selector 'tr', count: 2
      end
    end

    logout :cms_admin
  end

  test 'creating a Post' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_posts_url

    within(:xpath, "//div[@id='navbarCMS']") do
      find(:xpath, "//a[@id='dashboard-new-dropdown']").click
      find(:xpath, "//a[@class='dropdown-item'][1]").click
    end

    select 'Horticulture', from: 'post[category_id]'
    fill_in 'Title', with: 'Do not pluck flowers'

    content = 'Be a responsible resident, and care for flowers & trees.'
    find(:xpath, "//trix-editor[@id='post_content']").set(content)

    fill_in 'post_tag_list', with: '  Horticulture ,  Flower, do not pluck  '

    click_on 'Create Post'

    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Post was successfully created.'
    end
    click_on 'Back'

    logout :cms_admin
  end

  test 'creating a Post with insufficient data shows validation errors' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_posts_url

    within(:xpath, "//div[@id='navbarCMS']") do
      find(:xpath, "//a[@id='dashboard-new-dropdown']").click
      find(:xpath, "//a[@class='dropdown-item'][1]").click
    end

    click_on 'Create Post'

    assert_selector '.is-invalid', count: 3
    assert_selector '.invalid-feedback', count: 3
    assert_selector '.invalid-feedback', text: "Title can't be blank"
    assert_selector '.invalid-feedback', text: "Content can't be blank"

    logout :cms_admin
  end

  test 'updating a Post' do
    login_as @confirmed_board_admin, scope: :cms_admin

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

    logout :cms_admin
  end

  test 'destroying a Post' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_posts_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Post was successfully destroyed.'
    end

    logout :cms_admin
  end

  test 'shows a post' do
    login_as @confirmed_board_admin, scope: :cms_admin

    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    visit cms_post_url(@draft_post)

    within('.post__header') do
      assert_selector 'h1', text: @draft_post.title
      assert_selector 'span', text: @draft_post.created_at.strftime('%d %B %Y')
    end

    assert_selector '.post__content-tags mark', count: 2

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

    logout :cms_admin
  end

  test 'publishing a draft post' do
    login_as @confirmed_board_admin, scope: :cms_admin

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

    within('.post__header') do
      assert_selector 'span', text: @draft_post.reload.published_at.strftime('%d %B %Y')
    end

    logout :cms_admin
  end

  test 'make a post visible to visitors and toggle back to members' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_post_url(@finished_post)

    click_on 'Broadcast Post to Visitors'

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Post visibility status set for visitors.'
    end

    assert_selector "input.btn[value='Narrowcast to Members']"

    click_on 'Narrowcast to Members'

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body', text: 'Post visibility status set for members only.'
    end

    assert_selector "input.btn[value='Broadcast Post to Visitors']"

    logout :cms_admin
  end

  test 'that staff member can not publish a post' do
    login_as @confirmed_staff_admin, scope: :cms_admin

    @draft_post.documents.each do |document|
      attach_file_to_record document.attachment
    end

    visit cms_post_url(@draft_post)

    assert_no_selector 'form.button_to .btn', text: 'Publish'

    logout :cms_admin
  end

  test 'that staff member can not delete a published post' do
    login_as @confirmed_staff_admin, scope: :cms_admin

    visit published_cms_posts_url

    within('.posts__table tbody') do
      page.accept_confirm do
        click_on 'Destroy', match: :first
      end
    end

    within('.toast') do
      assert_selector '.toast-header strong', text: 'Error'
      assert_selector '.toast-body', text: 'Only board member can delete a post.'
    end

    logout :cms_admin
  end

  test 'lists all finished posts with pagination link' do
    visit posts_url

    assert_selector 'h3.post__title', count: 6

    find('.page-item.next a').click

    assert_selector 'h3.post__title', count: 3
  end
end
