class TenderProposal < ApplicationRecord
  belongs_to :tender_notice
  has_one :document, as: :documentable, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :document, presence: true
end
