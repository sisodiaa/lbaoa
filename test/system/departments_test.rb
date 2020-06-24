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

    assert_text 'Department was successfully created'
    click_on 'Back'
  end

  test 'updating a Department' do
    visit cms_departments_url
    click_on 'Edit', match: :first

    fill_in 'Description', with: 'New description'
    click_on 'Update Department'

    assert_text 'Department was successfully updated'
    assert_text 'New description'
    click_on 'Back'
  end
end
