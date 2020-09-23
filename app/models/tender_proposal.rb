class TenderProposal < ApplicationRecord
  include AASM

  after_commit :reload_token, on: :create

  belongs_to :tender_notice, inverse_of: :proposals
  has_one :document, as: :documentable, dependent: :destroy
  accepts_nested_attributes_for :document

  validates :name, presence: true
  validates :token, uniqueness: true
  validates_associated :document
  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: {
              scope: :tender_notice_id,
              message: 'already used before to submit a proposal for this tender notice'
            }

  enum proposal_state: {
    pending: 0,
    selected: 1,
    rejected: 2
  }

  aasm(
    :proposal,
    column: :proposal_state,
    enum: true,
    no_direct_assignment: true
  ) do
    state :pending, initial: true
    state :selected, :rejected

    event :selection do
      transitions from: :pending, to: :selected, if: :tender_notice_under_review?
    end

    event :rejection do
      transitions from: :pending, to: :rejected, if: :tender_notice_under_review?
    end
  end

  def to_param
    token
  end

  private

  def reload_token
    self[:token] = self.class.where(id: id).pick(:token)
  end

  def tender_notice_under_review?
    tender_notice.under_review?
  end
end
