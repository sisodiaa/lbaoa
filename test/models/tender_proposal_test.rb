require 'test_helper'

class TenderProposalTest < ActiveSupport::TestCase
  setup do
    @wirewala = tender_proposals(:wirewala)
    attach_file_to_record(
      @wirewala.document.attachment, 'sheet.xlsx'
    )
  end

  teardown do
    @wirewala = nil
  end

  test 'that name is present' do
    @wirewala.name = ''
    assert_not @wirewala.valid?, 'Name is required'
  end

  test 'that email is present' do
    @wirewala.email = ''
    assert_not @wirewala.valid?, 'Email is required'
  end

  test 'reject invalid email addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]

    invalid_addresses.each do |invalid_address|
      @wirewala.email = invalid_address
      assert_not @wirewala.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'accept valid email addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

    valid_addresses.each do |valid_address|
      @wirewala.email = valid_address
      assert @wirewala.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test 'that attached sheet is present' do
    @wirewala.document = nil
    assert_not @wirewala.valid?, 'Attached sheet is missing'
  end

  test 'that sheet is attached to associated document' do
    @wirewala.document.attachment = nil
    assert_not @wirewala.valid?, 'Sheet is not attached to the associated document'
  end

  test 'that only current tender notices can have proposals' do
    proposal = tender_proposals(:airwala)
    attach_file_to_record(
      proposal.build_document.attachment, 'sheet.xlsx'
    )
    assert_not proposal.valid?, 'TenderNotice state is not current'
  end
end
