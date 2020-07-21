require 'test_helper'

class CMS::PostPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @confirmed_staff_admin = admins(:confirmed_staff_admin)

    @draft_post = posts(:plantation)
  end

  teardown do
    @confirmed_board_admin = @confirmed_staff_admin = @draft_post = nil
  end

  test '#publish?' do
    assert_not CMS::PostPolicy.new(@confirmed_staff_admin, @draft_post).publish?
    assert CMS::PostPolicy.new(@confirmed_board_admin, @draft_post).publish?
  end
end
