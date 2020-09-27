module TMS
  class ProposalSelectionForm
    include ActiveModel::Model

    attr_accessor :reference_token, :token, :selection_reason

    def initialize(attributes = {})
      @reference_token = attributes.fetch(:reference_token, '')

      form_attributes = attributes.fetch(:proposal_selection_form, {})
      @token = form_attributes.fetch(:token, '')
      @selection_reason = form_attributes.fetch(:selection_reason, '')
    end

    def select
      return false unless valid?

      proposal_selection
    end

    def proposal_selection
      proposal.selection!
      reject_other_proposals
      update_notice_state_with_selection_reason
    rescue AASM::InvalidTransition
      errors.add(:base, 'Tender Notice is not under review')
      false
    end

    def notice
      TenderNotice.find_by(reference_token: reference_token)
    end

    def proposal
      notice.proposals.find_by(token: token)
    end

    def reject_other_proposals
      notice.proposals.pending.each(&:rejection!)
    end

    def update_notice_state_with_selection_reason
      notice.update(notice_state: 'archived', selection_reason: @selection_reason)
    end

    validate :tender_proposal_exist
    validates :selection_reason, presence: true

    def tender_proposal_exist
      errors.add(:email, 'is not found in proposals submitted for the tender notice') if proposal.nil?
    end
  end
end
