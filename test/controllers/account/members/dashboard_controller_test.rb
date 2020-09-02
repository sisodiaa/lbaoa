require 'test_helper'

module Account
  module Members
    class DashboardControllerTest < ActionDispatch::IntegrationTest
      setup do
        @confirmed_board_admin = admins(:confirmed_board_admin)
      end

      teardown do
        @confirmed_board_admin = nil
      end

      test 'unauthenticated access should redirect' do
        sign_in members(:confirmed_member), scope: :member

        get members_url
        assert_redirected_to new_admin_session_url

        sign_out :member
      end

      test 'only admin can access member dashboard' do
        sign_in @confirmed_board_admin, scope: :admin

        get members_url
        assert_response :success

        sign_out :admin
      end
    end
  end
end
