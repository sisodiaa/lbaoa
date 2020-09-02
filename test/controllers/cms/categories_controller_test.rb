require 'test_helper'

module CMS
  class CategoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @category = categories(:horticulture)
    end

    teardown do
      @confirmed_board_admin = nil
    end

    test 'unauthenticated access should redirect' do
      get cms_categories_url
      assert_redirected_to new_admin_session_url
    end

    test 'should get index' do
      sign_in @confirmed_board_admin, scope: :admin

      get cms_categories_url
      assert_response :success

      sign_out :admin
    end

    test 'should get new' do
      sign_in @confirmed_board_admin, scope: :admin

      get new_cms_category_url
      assert_response :success

      sign_out :admin
    end

    test 'should create category' do
      sign_in @confirmed_board_admin, scope: :admin

      assert_difference('Category.count') do
        post cms_categories_url, params: {
          category: {
            description: @category.description,
            title: @category.title
          }
        }
      end

      assert_redirected_to cms_category_url(Category.last)

      sign_out :admin
    end

    test 'should show category' do
      sign_in @confirmed_board_admin, scope: :admin

      get cms_category_url(@category)
      assert_response :success

      sign_out :admin
    end

    test 'should get edit' do
      sign_in @confirmed_board_admin, scope: :admin

      get edit_cms_category_url(@category)
      assert_response :success

      sign_out :admin
    end

    test 'should update category' do
      sign_in @confirmed_board_admin, scope: :admin

      patch cms_category_url(@category), params: {
        category: {
          description: @category.description,
          title: @category.title
        }
      }
      assert_redirected_to cms_category_url(@category)

      sign_out :admin
    end
  end
end
