module Tender
  class ProposalsController < ApplicationController
    before_action :set_notice, except: :show

    def index
      @proposals = @notice.proposals
      respond_to :js
    end

    def show
      @proposal = TenderProposal.find_by(token: params[:token])
    end

    def new
      @proposal = @notice.proposals.build
      @proposal.build_document
    end

    def create
      @proposal = @notice.proposals.build(proposal_params)

      if @proposal.save
        redirect_to @proposal, flash: { success: flash_message_for_success }
      else
        render :new
      end
    end

    private

    def set_notice
      @notice = TenderNotice.find_by(reference_token: params[:notice_reference_token])
    end

    def proposal_params
      params.require(:proposal).permit(:name, :email, :remark, document_attributes: [:attachment])
    end

    def flash_message_for_success
      'Proposal submitted successfully. You will also receive a confirmation '\
      'on the given email address.'
    end
  end
end
