require 'application_system_test_case'

class MembersDashboardTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_board_admin = admins(:confirmed_board_admin)
  end

  teardown do
    @confirmed_board_admin = nil
    Warden.test_reset!
  end

  test 'sub-menus of member dashboard' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit cms_dashboard_url

    click_on 'Members'

    within('#collapse-members') do
      click_on 'Approved'
    end

    within('table.members__table') do
      assert_selector '.members__table-row', count: 1
      assert_selector 'td', text: 'member_one@example.com'
    end

    within('#collapse-members') do
      click_on 'Pending'
    end

    within('table.members__table') do
      assert_selector '.members__table-row', count: 1
      assert_no_selector 'td', text: 'member_two@example.com'
      assert_selector 'td', text: 'member_three@example.com'
    end

    within('#collapse-members') do
      click_on 'Flagged'
    end

    within('table.members__table') do
      assert_selector '.members__table-row', count: 1
      assert_selector 'td', text: 'member_four@example.com'
    end

    within('#collapse-members') do
      click_on 'Archived'
    end

    within('table.members__table') do
      assert_selector '.members__table-row', count: 1
      assert_selector 'td', text: 'member_five@example.com'
    end

    within('#collapse-members') do
      click_on 'Bogus'
    end

    within('table.members__table') do
      assert_selector '.members__table-row', count: 1
      assert_selector 'td', text: 'member_six@example.com'
    end

    logout :cms_admin
  end

  test 'approve a pending member' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit pending_members_url

    assert_no_selector '#memberEditModal.modal'

    within('table.members__table') do
      click_on 'Edit'
    end

    assert_selector '#memberEditModal.modal.show'

    within('#memberEditModalBody form') do
      assert_selector "input#member_email[value='member_three@example.com']"

      select 'Approved', from: 'member[status]'
      click_on 'Update Member'
    end

    within('table.members__table') do
      assert_no_selector '.members__table-row'
    end

    within('#collapse-members') do
      click_on 'Approved'
    end

    within('table.members__table') do
      assert_selector '.members__table-row', count: 2
      assert_text 'member_one@example.com'
      assert_text 'member_three@example.com'
    end

    logout :cms_admin
  end

  test 'that no data will be shown for random status parameter' do
    login_as @confirmed_board_admin, scope: :cms_admin

    visit members_url(status: 'lol')

    assert_selector 'table.members__table'
    assert_no_selector '.members__table-row'

    logout :cms_admin
  end
end
