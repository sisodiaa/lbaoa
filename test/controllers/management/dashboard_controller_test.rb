require 'test_helper'

module Management
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
    end

    teardown do
      @confirmed_board_admin = nil
    end

    test 'unauthenticated access should redirect' do
      get management_dashboard_url
      assert_redirected_to new_admin_session_url
    end
  end
end
