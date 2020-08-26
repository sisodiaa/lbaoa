require 'application_system_test_case'

class SearchPostsTest < ApplicationSystemTestCase
  setup do
    Warden.test_mode!
    @confirmed_member = members(:confirmed_member)
    login_as @confirmed_member, scope: :member
  end

  teardown do
    logout :member
    @confirmed_member = nil
    Warden.test_reset!
  end

  test 'search_posts pages without params only show search form' do
    visit search_posts_url

    assert_selector '#form-search-post'
    assert_no_selector '#results-search-post'
  end

  test 'validation error messages' do
    visit search_posts_url

    within('form') do
      fill_in 'search_post_form_tag_list', with: 'tag1, tag2, tag3, tag4'
      click_on 'Search'
    end

    assert_selector '#search_post_form_tag_list.is-invalid'
    assert_selector '.invalid-feedback', text: 'Tags should be 3 or fewer'

    within('form') do
      fill_in 'search_post_form_tag_list', with: ''
      fill_in 'search_post_form_start_date', with: '2020-08-16'
      fill_in 'search_post_form_end_date', with: '2020-08-14'
      click_on 'Search'
    end

    assert_selector '#search_post_form_start_date.is-invalid'
    assert_selector '.invalid-feedback', text: 'Start date should be before end date'

    within('form') do
      fill_in 'search_post_form_start_date', with: ''
      fill_in 'search_post_form_end_date', with: '2020-08-14'
      click_on 'Search'
    end

    assert_selector '#search_post_form_start_date.is-invalid'
    assert_selector '.invalid-feedback', text: 'Start date is required if end date is present'
  end

  test 'showing search results' do
    visit search_posts_url

    within('form') do
      select 'Helpdesk', from: 'search_post_form[category]'
      click_on 'Search'
    end

    within('#results-search-post') do
      assert_selector '#results-search-post__count', text: 4
      assert_selector '.results-search-post__info', count: 4
    end
  end
end
