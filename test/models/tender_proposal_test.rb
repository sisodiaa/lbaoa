require 'test_helper'

class TenderProposalTest < ActiveSupport::TestCase
  setup do
    @pure_air = tender_proposals(:pure_air)
    attach_file_to_record(
      @pure_air.document.attachment, 'sheet.xlsx'
    )
  end

  teardown do
    @pure_air = nil
  end

  test 'that name is present' do
    @pure_air.name = ''
    assert_not @pure_air.valid?, 'Name is required'
  end

  test 'that email is present' do
    @pure_air.email = ''
    assert_not @pure_air.valid?, 'Email is required'
  end

  test 'reject invalid email addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @pure_air.email = invalid_address
      assert_not @pure_air.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'accept valid email addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @pure_air.email = valid_address
      assert @pure_air.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'that attached sheet is present' do
    @pure_air.document = nil
    assert_not @pure_air.valid?, 'Attached sheet is missing'
  end

  test 'that sheet is attached to associated document' do
    @pure_air.document.attachment = nil
    assert_not @pure_air.valid?, 'Sheet is not attached to the associated document'
  end
end
