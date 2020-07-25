require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  setup do
    @category = categories(:horticulture)
  end

  teardown do
    @category = nil
  end

  test 'that title is given' do
    @category.title = ''
    assert_not @category.valid?, 'Title is not present'
  end

  test 'that title is not longer than 50 characters' do
    @category.title = 'a' * 51
    assert_not @category.valid?, 'Title is longer than 50 characters'
  end

  test 'that description is given' do
    @category.description = ''
    assert_not @category.valid?, 'Description is not present'
  end

  test 'that description is not longer than 1024 characters' do
    @category.description = 'a' * 1025
    assert_not @category.valid?, 'Description is longer than 1024 characters'
  end

  test 'that title is saved in lowercase' do
    Category.create!(title: 'Medical', description: 'To provide meical help')

    assert_equal 'medical', Category.last.title
  end
end
