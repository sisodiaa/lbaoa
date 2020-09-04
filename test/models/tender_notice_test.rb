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

  test 'that title is present' do
    @published_tender_notice.title = ''
    assert_not @published_tender_notice.valid?, 'Title is required'
  end

  test 'that title is saved in lowercase' do
    TenderNotice.create!(title: 'TITLE IN CAPS', reference_token: 'a9')

    assert_equal 'title in caps', TenderNotice.last.title
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
    @published_tender_notice.opening_on = Time.current - 3.days
    assert_raise(AASM::InvalidTransition) { @published_tender_notice.publish }
  end

  test 'that manual assignment of publication_state will raise error' do
    assert_raise(AASM::NoDirectAssignmentError) do
      @published_tender_notice.publication_state = :draft
    end
  end

  test 'that template is required' do
    assert_raise(AASM::InvalidTransition) { @draft_tender_notice.publish }
  end
end
