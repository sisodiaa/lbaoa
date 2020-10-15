module TMS
  class NoticesController < ApplicationController
    include Pagy::Backend

    layout 'admin_sidebar'

    before_action :authenticate_admin!
    before_action :set_notice, only: %i[show edit update publish destroy]

    def index
      @status = params[:status]
      @pagy, @notices = set_notices
    end

    def show
      @proposals = @notice.proposals.includes(document: { attachment_attachment: :blob })
      @proposal_selection_form = TMS::ProposalSelectionForm.new if @notice.under_review?
    end

    def new
      @notice = TenderNotice.new
    end

    def edit
      authorize @notice, policy_class: TenderNoticePolicy
    end

    def create
      @notice = TenderNotice.new(notice_params)

      if @notice.save
        redirect_to tms_notice_path(@notice),
                    flash: { success: 'Tender Notice was successfully created.' }
      else
        render :new
      end
    end

    def update
      authorize @notice, policy_class: TenderNoticePolicy

      if @notice.update(notice_params)
        redirect_to tms_notice_path(@notice),
                    flash: { success: 'Tender Notice was successfully updated.' }
      else
        render :edit
      end
    end

    def publish
      return unless params.dig(:notice, :publish_notice) == 'true'

      authorize @notice, policy_class: TenderNoticePolicy

      @notice.publish if @notice.valid?(:notice_publication)

      if @notice.published? && @notice.save
        redirect_to tms_notice_path(@notice),
                    flash: { success: 'Tender Notice was successfully published.' }
      else
        render :show
      end
    end

    def destroy
      authorize @notice, policy_class: TenderNoticePolicy

      @notice.destroy
      redirect_to tms_notices_path,
                  flash: { success: 'Tender Notice was successfully destroyed.' }
    end

    private

    def pundit_user
      current_admin
    end

    def set_notice
      @notice = TenderNotice.find_by(reference_token: params[:reference_token])
    end

    def set_notices
      if params[:status] == 'draft'
        pagy(TenderNotice.draft.order('created_at ASC'), items: 10)
      else
        pagy(published_tender_notices.order('published_at DESC'), items: 10)
      end
    end

    def published_tender_notices
      TenderNotice.published.try!(@status.to_sym)
    rescue NoMethodError
      TenderNotice.none
    end

    def notice_params
      params.require(:notice).permit(
        :reference_token, :title, :description, :specification,
        :terms_and_conditions, :opening_on_string, :closing_on_string
      )
    end
  end
end
