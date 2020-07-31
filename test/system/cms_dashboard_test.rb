require 'application_system_test_case'

class CMSDashboardTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)
  end

  teardown do
    @confirmed_board_admin = nil
    Warden.test_reset!
  end

  test 'cms dashboard' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_dashboard_url

    within('#cms-dashboard') do
      assert_selector :xpath, "//tbody/tr[@class='dashboard__table-row'][1]/td[2]", text: Post.count
      assert_selector :xpath, "//tbody/tr[@class='dashboard__table-row'][2]/td[2]", text: Category.count
    end

    logout :cms_admin
  end
end
