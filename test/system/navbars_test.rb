require 'application_system_test_case'

class NavbarsTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_member = members(:confirmed_member)
  end

  teardown do
    @confirmed_member = nil
    Warden.test_reset!
  end

  test 'that navbar nav-items get active class apended' do
    visit root_url

    within('nav.navbar ul.navbar-nav') do
      assert_selector '.active a.nav-link', text: 'Home'

      click_on 'About Us'
    end

    within('nav.navbar ul.navbar-nav') do
      assert_selector '.active a.nav-link', text: 'About Us'

      click_on 'Posts'
    end

    within('nav.navbar ul.navbar-nav') do
      assert_selector '.active a.nav-link', text: 'Posts'

      click_on 'Tender Notices'
    end

    within('nav.navbar ul.navbar-nav') do
      assert_selector '.active a.nav-link', text: 'Tender Notices'

      click_on 'Member'
      click_on 'Log In'
    end

    within('nav.navbar ul.navbar-nav') do
      assert_selector '.active a.nav-link', text: 'Member'
    end
  end

  test 'member dropdown' do
    visit root_url

    within('nav.navbar') do
      click_on 'Member'
      click_on 'Log In'
    end

    within('form#new_member') do
      fill_in 'member_email', with: @confirmed_member.email
      fill_in 'member_password', with: 'password'

      click_on 'Log in'
    end

    within('nav.navbar') do
      click_on @confirmed_member.email.to_s
      click_on 'Logout'
    end

    assert_selector 'section#main'
  end

  test 'search nav item is shown only to authenticated members' do
    visit root_url

    within('nav.navbar') do
      assert_no_selector 'li a.nav-link', text: 'Search'
    end

    login_as @confirmed_member, scope: :member

    visit root_url

    within('nav.navbar') do
      assert_selector 'li a.nav-link', text: 'Search'
    end

    logout :member
  end
end
