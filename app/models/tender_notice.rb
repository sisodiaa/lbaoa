class TenderNotice < ApplicationRecord
  include AASM

  has_one :document, as: :documentable, dependent: :destroy

  before_save { title.downcase! }

  validates :reference_token, presence: true, format: {
    with: /\A[\w-]+\z/,
    message: 'only allow letter, number, underscore, and hyphen'
  }
  validates :title, presence: true

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
      transitions from: :draft, to: :published, if: :upcoming_tender_notice_have_document?
    end
  end

  private

  def upcoming_tender_notice_have_document?
    upcoming_tender_notice? && document.present?
  end

  def upcoming_tender_notice?
    DateTime.current <= opening_on
  end
end
