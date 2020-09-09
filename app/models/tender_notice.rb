class TenderNotice < ApplicationRecord
  include AASM

  has_one :document, as: :documentable, dependent: :destroy

  validates :reference_token, presence: true, uniqueness: true, format: {
    with: /\A[\w-]+\z/,
    message: 'only allow letter, number, underscore, and hyphen'
  }
  validates :title, presence: true
  validates_with TenderNoticeTimeFrameValidator, on: :notice_publication
  validates :document, presence: true, on: :notice_publication

  enum publication_state: {
    draft: 0,
    published: 1
  }

  enum notice_state: {
    upcoming: 0,
    current: 1,
    archived: 2
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
    self.opening_on = DateTime.parse(opening_on_str)
  rescue ArgumentError
    self.opening_on = nil
  end

  def closing_on_string
    return closing_on.to_s if closing_on.nil?

    closing_on.to_s(:db)
  end

  def closing_on_string=(closing_on_str)
    self.closing_on = DateTime.parse(closing_on_str)
  rescue ArgumentError
    self.closing_on = nil
  end

  private

  def upcoming_tender_notice?
    DateTime.current <= opening_on
  end
end
