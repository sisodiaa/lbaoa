require 'test_helper'

class TenderNoticeTest < ActiveSupport::TestCase
  setup do
    @draft_tender_notice = tender_notices(:boom_barriers)
    @published_tender_notice = tender_notices(:air_quality_monitors)
  end

  teardown do
    @draft_tender_notice = @published_tender_notice = nil
  end

  test 'that reference_token only allows letter, number, underscore, hyphen' do
    @draft_tender_notice.reference_token = 'AUG/2020@LB/club'
    assert_not @draft_tender_notice.valid?, 'Prohibited chars in reference_token'

    @draft_tender_notice.reference_token = 'AUG-2020_LB-club'
    assert @draft_tender_notice.valid?
  end

  test 'that reference_token is present' do
    @draft_tender_notice.reference_token = ''
    assert_not @draft_tender_notice.valid?, 'Reference Token is required'
  end

  test 'that reference_token is unique' do
    new_tender_notice = TenderNotice.new(
      reference_token: @published_tender_notice.reference_token, title: 'abc'
    )

    assert_not new_tender_notice.valid?, 'Reference Token needs to be unique'
  end

  test 'that title is present' do
    @published_tender_notice.title = ''
    assert_not @published_tender_notice.valid?, 'Title is required'
  end

  test 'that publish event changes the publication_state' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )

    assert @draft_tender_notice.draft?
    assert_not @draft_tender_notice.published?

    @draft_tender_notice.publish

    assert_not @draft_tender_notice.draft?
    assert @draft_tender_notice.published?
  end

  test 'that only an upcoming notice gets published' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )

    @draft_tender_notice.opening_on = Time.current - 3.days

    @draft_tender_notice.publish

    assert_equal ['should be after current date and time'],
                 @draft_tender_notice.errors[:opening_on]
  end

  test 'that manual assignment of publication_state will raise error' do
    assert_raise(AASM::NoDirectAssignmentError) do
      @published_tender_notice.publication_state = :draft
    end
  end

  test 'that template is required' do
    assert_not @draft_tender_notice.valid?(:notice_publication),
               'Attachment is missing'
  end

  test 'that opening date is required for publishing the notice' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )

    @draft_tender_notice.opening_on = nil

    assert_not @draft_tender_notice.valid?(:notice_publication), 'Opening date is missing'
  end

  test 'that closing date is required for publishing the notice' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )

    @draft_tender_notice.closing_on = nil

    assert_not @draft_tender_notice.valid?(:notice_publication), 'Closing date is missing'
  end

  test 'that opening_on datetime should be before closing_on' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )

    @draft_tender_notice.opening_on = @draft_tender_notice.closing_on + 3.days

    assert_not @draft_tender_notice.valid?(:notice_publication),
               'Opening date should come before closing date'
  end

  test 'set opening_on to nil for invaid datetime' do
    @published_tender_notice.opening_on_string = '2001-02-36 14:05'
    assert_nil @published_tender_notice.opening_on
  end

  test 'set closing_on to nil for invaid datetime' do
    @published_tender_notice.closing_on_string = '2001-22-30 14:05'
    assert_nil @published_tender_notice.closing_on
  end

  test 'that publishing a notice sets the published_at' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )

    assert_nil @draft_tender_notice.published_at

    @draft_tender_notice.publish

    assert_equal DateTime.current.to_i, @draft_tender_notice.published_at.to_i
  end

  test 'set error if transition to published state fails' do
    attach_file_to_record(
      @draft_tender_notice.build_document.attachment, 'tender_notice.xlsx'
    )

    @draft_tender_notice.opening_on = Time.current - 3.days
    @draft_tender_notice.publish

    assert_equal ['should be after current date and time'],
                 @draft_tender_notice.errors[:opening_on]
  end
end
