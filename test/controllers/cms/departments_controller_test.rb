require 'test_helper'

module CMS
  class DepartmentsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @department = departments(:horticulture)
    end

    test 'should get index' do
      get cms_departments_url
      assert_response :success
    end

    test 'should get new' do
      get new_cms_department_url
      assert_response :success
    end

    test 'should create department' do
      assert_difference('Department.count') do
        post cms_departments_url, params: {
          department: {
            description: @department.description,
            title: @department.title
          }
        }
      end

      assert_redirected_to cms_department_url(Department.last)
    end

    test 'should show department' do
      get cms_department_url(@department)
      assert_response :success
    end

    test 'should get edit' do
      get edit_cms_department_url(@department)
      assert_response :success
    end

    test 'should update department' do
      patch cms_department_url(@department), params: {
        department: {
          description: @department.description,
          title: @department.title
        }
      }
      assert_redirected_to cms_department_url(@department)
    end
  end
end
