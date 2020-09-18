class TenderProposal < ApplicationRecord
  belongs_to :tender_notice, -> { where notice_state: :current }, inverse_of: :proposals
  has_one :document, as: :documentable, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :document, presence: true
  validates_associated :document
end
