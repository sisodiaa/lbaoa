require 'test_helper'

class AdminTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
  end

  teardown do
    @confirmed_board_admin = nil
  end

  test 'that first_name is present' do
    @confirmed_board_admin.first_name = ''
    assert_not @confirmed_board_admin.valid?, 'First name is not present'
  end

  test 'that last_name is present' do
    @confirmed_board_admin.last_name = ''
    assert_not @confirmed_board_admin.valid?, 'Last name is not present'
  end

  test 'that ArgumentError is raised upon invalid assignment to affiliation' do
    assert_raises ArgumentError do
      @confirmed_board_admin.affiliation = 'resident'
    end
  end

  test 'that ArgumentError is raised upon invalid assignment to status' do
    assert_raises ArgumentError do
      @confirmed_board_admin.status = 'banned'
    end
  end
end
