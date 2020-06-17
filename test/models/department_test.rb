require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  setup do
    @department = departments(:horticulture)
  end

  teardown do
    @department = nil
  end

  test 'that title is given' do
    @department.title = ''
    assert_not @department.valid?, 'Title is not present'
  end

  test 'that title is not longer than 50 characters' do
    @department.title = 'a' * 51
    assert_not @department.valid?, 'Title is longer than 50 characters'
  end

  test 'that description is given' do
    @department.description = ''
    assert_not @department.valid?, 'Description is not present'
  end

  test 'that description is not longer than 1024 characters' do
    @department.description = 'a' * 1025
    assert_not @department.valid?, 'Description is longer than 1024 characters'
  end
end
