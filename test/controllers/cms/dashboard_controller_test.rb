require 'test_helper'

module CMS
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
    end

    teardown do
      @confirmed_board_admin = nil
    end

    test 'unauthenticated access should redirect' do
      get cms_dashboard_url
      assert_redirected_to new_cms_admin_session_url
    end
  end
end
