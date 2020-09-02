require 'application_system_test_case'

class ManagementDashboardTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)
  end

  teardown do
    @confirmed_board_admin = nil
    Warden.test_reset!
  end

  test 'management dashboard' do
    login_as @confirmed_board_admin, scope: :admin

    visit management_dashboard_url

    within('#management-dashboard') do
      assert_selector :xpath, "//tbody/tr[@class='dashboard__table-row'][1]/td[2]", text: Post.count
      assert_selector :xpath, "//tbody/tr[@class='dashboard__table-row'][2]/td[2]", text: Category.count
      assert_selector :xpath, "//tbody/tr[@class='dashboard__table-row'][3]/td[2]", text: Member.confirmed.count
    end

    logout :admin
  end
end
