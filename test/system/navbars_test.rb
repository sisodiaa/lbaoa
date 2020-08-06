require 'application_system_test_case'

class NavbarsTest < ApplicationSystemTestCase
  test 'that navbar nav-items get active class apended' do
    visit root_url

    within('nav.navbar ul.navbar-nav') do
      assert_selector 'li.nav-item.active a.nav-link', text: 'Home'
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
end
