module TMS
  class NoticesController < ApplicationController
    include Pagy::Backend

    layout 'cms_sidebar'

    before_action :authenticate_admin!
    before_action :set_notice, only: %i[show edit update destroy]

    def index
      @status = params[:status]
      @pagy, @notices = set_notices
    end

    def show; end

    def new
      @notice = TenderNotice.new
    end

    def edit
      authorize @notice, policy_class: TenderNoticePolicy
    end

    def create
      @notice = TenderNotice.new(notice_params)

      if @notice.save
        redirect_to tms_notice_url(@notice),
                    flash: { success: 'Tender Notice was successfully created.' }
      else
        render :new
      end
    end

    def update
      authorize @notice, policy_class: TenderNoticePolicy

      if @notice.update(notice_params)
        redirect_to tms_notice_url(@notice),
                    flash: { success: 'Tender Notice was successfully updated.' }
      else
        render :edit
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
