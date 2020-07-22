require 'test_helper'

class CMS::PostPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)
    @confirmed_staff_admin = admins(:confirmed_staff_admin)

    @draft_post = posts(:plantation)
    @published_post = posts(:lotus)
  end

  teardown do
    @draft_post = @published_post = nil
    @confirmed_board_admin = @confirmed_staff_admin = nil
  end

  test '#publish?' do
    assert_not CMS::PostPolicy.new(@confirmed_staff_admin, @draft_post).publish?
    assert CMS::PostPolicy.new(@confirmed_board_admin, @draft_post).publish?
  end

  test '#destroy?' do
    assert CMS::PostPolicy.new(@confirmed_staff_admin, @draft_post).destroy?

    assert_not CMS::PostPolicy.new(@confirmed_staff_admin, @published_post).destroy?
    assert CMS::PostPolicy.new(@confirmed_board_admin, @published_post).destroy?
  end
end
