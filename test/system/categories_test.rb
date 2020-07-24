require 'application_system_test_case'

class CategoriesTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @category = categories(:horticulture)
  end

  teardown do
    @category = nil

    @confirmed_board_admin = nil
    Warden.test_reset!
  end

  test 'visiting the index' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_categories_url
    assert_selector 'h1', text: 'Categories'

    logout :cms_admin
  end

  test 'creating a Category' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_categories_url
    click_on 'New Category'

    fill_in 'Description', with: 'Fire and Safety'
    fill_in 'Title', with: 'Ensuring residents safety from fire'
    click_on 'Create Category'

    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body',
                      text: 'Category was successfully created.'
    end
    click_on 'Back'

    logout :cms_admin
  end

  test 'updating a Category' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_categories_url
    click_on 'Edit', match: :first

    fill_in 'Description', with: 'New description'
    click_on 'Update Category'

    assert_text 'New description'
    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body',
                      text: 'Category was successfully updated.'
    end
    click_on 'Back'

    logout :cms_admin
  end

  test 'updating a Category with insufficient data show validation errors' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_categories_url
    click_on 'Edit', match: :first

    fill_in 'Description', with: ''
    click_on 'Update Category'

    assert_selector '.is-invalid'
    assert_selector '.invalid-feedback', text: "Description can't be blank"

    logout :cms_admin
  end
end
