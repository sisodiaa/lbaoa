require 'test_helper'

module CMS
  class DepartmentsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @confirmed_board_admin = admins(:confirmed_board_admin)
      @department = departments(:horticulture)
    end

    teardown do
      @confirmed_board_admin = nil
    end

    test 'unauthenticated access should redirect' do
      get cms_departments_url
      assert_redirected_to new_cms_admin_session_url
    end

    test 'should get index' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      get cms_departments_url
      assert_response :success

      sign_out :cms_admin
    end

    test 'should get new' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      get new_cms_department_url
      assert_response :success

      sign_out :cms_admin
    end

    test 'should create department' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      assert_difference('Department.count') do
        post cms_departments_url, params: {
          department: {
            description: @department.description,
            title: @department.title
          }
        }
      end

      assert_redirected_to cms_department_url(Department.last)

      sign_out :cms_admin
    end

    test 'should show department' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      get cms_department_url(@department)
      assert_response :success

      sign_out :cms_admin
    end

    test 'should get edit' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      get edit_cms_department_url(@department)
      assert_response :success

      sign_out :cms_admin
    end

    test 'should update department' do
      sign_in @confirmed_board_admin, scope: :cms_admin

      patch cms_department_url(@department), params: {
        department: {
          description: @department.description,
          title: @department.title
        }
      }
      assert_redirected_to cms_department_url(@department)

      sign_out :cms_admin
    end
  end
end
