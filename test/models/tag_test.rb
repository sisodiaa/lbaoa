require 'test_helper'

class TagTest < ActiveSupport::TestCase
  setup do
    @tag = tags(:plant)
  end

  teardown do
    @tag = nil
  end

  test 'that name of tag is present' do
    @tag.name = ''
    assert_not @tag.valid?, 'Name is not present'
  end

  test 'that name is saved in lowercase' do
    Tag.create!(name: 'Fire Alarm')

    assert_equal 'fire alarm', Tag.last.name
  end
end
