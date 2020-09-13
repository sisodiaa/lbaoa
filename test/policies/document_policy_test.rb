require 'test_helper'

class DocumentPolicyTest < ActiveSupport::TestCase
  setup do
    @confirmed_board_admin = admins(:confirmed_board_admin)

    @excel_document = documents(:excel)
    @xls_document = documents(:xls)
    @jpg_document = documents(:jpg)
  end

  teardown do
    @excel_document = @xls_document = @jpg_document = nil
    @confirmed_board_admin = nil
  end

  test '#destroy' do
    assert DocumentPolicy.new(@confirmed_board_admin, @xls_document).destroy?
    assert DocumentPolicy.new(@confirmed_board_admin, @jpg_document).destroy?
    assert_not DocumentPolicy.new(@confirmed_board_admin, @excel_document).destroy?
  end
end
