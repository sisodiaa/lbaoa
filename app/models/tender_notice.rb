class TenderNotice < ApplicationRecord
  include AASM

  after_update :schedule_jobs_for_opening_and_closing_tender_notice

  has_one :document, as: :documentable, dependent: :destroy
  has_many :proposals, class_name: 'TenderProposal', inverse_of: :tender_notice

  validates :reference_token, presence: true, uniqueness: true, format: {
    with: /\A[\w-]+\z/,
    message: 'only allow letter, number, underscore, and hyphen'
  }
  validates :title, presence: true
  validates_with TenderNoticeTimeFrameValidator, on: :notice_publication
  validates :document,
            presence: { message: 'attachment is required for publishing the notice' },
            on: :notice_publication

  enum publication_state: {
    draft: 0,
    published: 1
  }

  enum notice_state: {
    upcoming: 0,
    current: 1,
    under_review: 2,
    archived: 3
  }

  aasm(
    :publication,
    column: :publication_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :draft, initial: true
    state :published

    event :publish do
      after do
        self.published_at = DateTime.current
      end

      error do |e|
        e.is_a?(AASM::InvalidTransition) &&
          errors.add(:opening_on, 'should be after current date and time')
      end

      transitions from: :draft, to: :published, if: :upcoming_tender_notice?
    end
  end

  def to_param
    reference_token
  end

  def opening_on_string
    return opening_on.to_s if opening_on.nil?

    opening_on.to_s(:db)
  end

  def opening_on_string=(opening_on_str)
    self.opening_on = Time.zone.parse(opening_on_str)
  rescue ArgumentError
    self.opening_on = nil
  end

  def closing_on_string
    return closing_on.to_s if closing_on.nil?

    closing_on.to_s(:db)
  end

  def closing_on_string=(closing_on_str)
    self.closing_on = Time.zone.parse(closing_on_str)
  rescue ArgumentError
    self.closing_on = nil
  end

  private

  def upcoming_tender_notice?
    DateTime.current <= opening_on
  end

  def schedule_jobs_for_opening_and_closing_tender_notice
    return if draft? || archived?

    upcoming? && OpenTenderNoticeJob
      .set(wait_until: opening_on)
      .perform_later(reference_token)

    current? && CloseTenderNoticeJob
      .set(wait_until: closing_on)
      .perform_later(reference_token)
  end
end
