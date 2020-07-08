require 'application_system_test_case'

class DepartmentsTest < ApplicationSystemTestCase
  setup do
    @department = departments(:horticulture)
  end

  test 'visiting the index' do
    visit cms_departments_url
    assert_selector 'h1', text: 'Departments'
  end

  test 'creating a Department' do
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
  end

  test 'updating a Department' do
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
  end

  test 'updating a Department with insufficient data show validation errors' do
    visit cms_departments_url
    click_on 'Edit', match: :first

    fill_in 'Description', with: ''
    click_on 'Update Department'

    assert_selector '.is-invalid'
    assert_selector '.invalid-feedback', text: "Description can't be blank"
  end
end
