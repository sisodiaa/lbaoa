module TMS
  class ProposalSelectionController < ApplicationController
    before_action :authenticate_admin!

    layout 'cms_sidebar'

    def create
      @proposal_selection_form = TMS::ProposalSelectionForm.new(params)

      authorize @proposal_selection_form,
                policy_class: TMS::ProposalSelectionFormPolicy

      if @proposal_selection_form.select
        redirect_to tms_notice_path(@proposal_selection_form.notice),
                    flash: { success: 'Proposal selected successfully.' }
      else
        @notice = @proposal_selection_form.notice
        @proposals = @notice.proposals.includes(document: { attachment_attachment: :blob })
        render 'tms/notices/show'
      end
    end

    def pundit_user
      current_admin
    end
  end
end
