require 'application_system_test_case'

class NavbarsTest < ApplicationSystemTestCase
  test 'that navbar nav-items get active class apended' do
    visit root_url

    within('nav.navbar ul.navbar-nav') do
      assert_selector 'li.nav-item a.nav-link', text: 'Home'
      assert_selector 'li.nav-item a.nav-link', text: 'About Us'
      assert_selector 'li.nav-item a.nav-link', text: 'Posts'

      click_on 'About Us'
    end

    within('nav.navbar ul.navbar-nav') do
      assert_selector 'li.nav-item a.nav-link', text: 'Home'
      assert_selector 'li.nav-item.active a.nav-link', text: 'About Us'
      assert_selector 'li.nav-item a.nav-link', text: 'Posts'

      click_on 'Posts'
    end

    within('nav.navbar ul.navbar-nav') do
      assert_selector 'li.nav-item a.nav-link', text: 'Home'
      assert_selector 'li.nav-item a.nav-link', text: 'About Us'
      assert_selector 'li.nav-item.active a.nav-link', text: 'Posts'
    end
  end

  test 'member dropdown' do
    confirmed_member = members(:confirmed_member)

    visit root_url

    within('nav.navbar') do
      click_on 'Member'
      click_on 'Log In'
    end

    within('form#new_member') do
      fill_in 'member_email', with: confirmed_member.email
      fill_in 'member_password', with: 'password'

      click_on 'Log in'
    end

    within('nav.navbar') do
      click_on confirmed_member.email.to_s
      click_on 'Logout'
    end

    assert_selector 'section#main'

    confirmed_member = nil
  end
end
