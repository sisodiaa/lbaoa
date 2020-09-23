require 'test_helper'

class TenderProposalTest < ActiveSupport::TestCase
  setup do
    @wirewala = tender_proposals(:wirewala)
    @waterwala = tender_proposals(:waterwala)

    attach_file_to_record(
      @wirewala.document.attachment, 'sheet.xlsx'
    )
    attach_file_to_record(
      @waterwala.document.attachment, 'sheet.xlsx'
    )
  end

  teardown do
    @wirewala = @waterwala = nil
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

  test 'that sheet is attached to associated document' do
    @wirewala.document.attachment = nil
    assert_not @wirewala.valid?, 'Sheet is not attached to the associated document'
  end

  test 'that token value is unique' do
    assert_not @wirewala.dup.valid?, 'Token value is not unique'
  end

  test 'that email is unique per notice' do
    proposal = TenderProposal.new(
      name: 'abc',
      email: @wirewala.email,
      tender_notice_id: @wirewala.tender_notice_id
    )
    attach_file_to_record(
      proposal.build_document.attachment, 'sheet.xlsx'
    )

    assert_not proposal.valid?, 'Email per notice needs to be unique'
  end

  test 'that manual assignment of proposal_state will raise error' do
    assert_raise(AASM::NoDirectAssignmentError) do
      @waterwala.proposal_state = :selected
    end
  end

  test 'that selection event will change the proposal_state' do
    assert @waterwala.pending?
    assert_not @waterwala.selected?

    @waterwala.selection

    assert_not @waterwala.pending?
    assert @waterwala.selected?
  end

  test 'that rejection event will change the proposal_state' do
    assert @waterwala.pending?
    assert_not @waterwala.rejected?

    @waterwala.rejection

    assert_not @waterwala.pending?
    assert @waterwala.rejected?
  end

  test 'that error is raised upon selection event if notice is not under review' do
    assert_raise(AASM::InvalidTransition) { @wirewala.selection }
  end

  test 'that error is raised upon rejection event if notice is not under review' do
    assert_raise(AASM::InvalidTransition) { @wirewala.rejection }
  end
end
