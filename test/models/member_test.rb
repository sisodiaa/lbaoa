require 'test_helper'

class MemberTest < ActiveSupport::TestCase
  test 'that ArgumentError is raised upon invalid assignment to status' do
    assert_raises ArgumentError do
      members(:confirmed_member).status = 'banned'
    end
  end
end
