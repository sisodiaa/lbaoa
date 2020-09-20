class TenderProposal < ApplicationRecord
  after_commit :reload_token, on: :create

  belongs_to :tender_notice, -> { where notice_state: :current }, inverse_of: :proposals
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

  def to_param
    token
  end

  private

  def reload_token
    self[:token] = self.class.where(id: id).pick(:token)
  end
end
