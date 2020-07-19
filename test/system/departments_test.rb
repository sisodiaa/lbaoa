require 'application_system_test_case'

class DepartmentsTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @department = departments(:horticulture)
  end

  teardown do
    @department = nil

    @confirmed_board_admin = nil
    Warden.test_reset!
  end

  test 'visiting the index' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_departments_url
    assert_selector 'h1', text: 'Departments'

    logout :cms_admin
  end

  test 'creating a Department' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_departments_url
    click_on 'New Department'

    fill_in 'Description', with: 'Fire and Safety'
    fill_in 'Title', with: 'Ensuring residents safety from fire'
    click_on 'Create Department'

    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body',
                      text: 'Department was successfully created.'
    end
    click_on 'Back'

    logout :cms_admin
  end

  test 'updating a Department' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_departments_url
    click_on 'Edit', match: :first

    fill_in 'Description', with: 'New description'
    click_on 'Update Department'

    assert_text 'New description'
    assert_no_selector 'p#notice'
    within('.toast') do
      assert_selector '.toast-header strong', text: 'Success'
      assert_selector '.toast-body',
                      text: 'Department was successfully updated.'
    end
    click_on 'Back'

    logout :cms_admin
  end

  test 'updating a Department with insufficient data show validation errors' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_departments_url
    click_on 'Edit', match: :first

    fill_in 'Description', with: ''
    click_on 'Update Department'

    assert_selector '.is-invalid'
    assert_selector '.invalid-feedback', text: "Description can't be blank"

    logout :cms_admin
  end
end
