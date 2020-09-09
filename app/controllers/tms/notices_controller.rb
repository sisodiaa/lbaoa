module TMS
  class NoticesController < ApplicationController
    layout 'cms_sidebar'

    before_action :authenticate_admin!
    before_action :set_notice, only: %i[show edit update destroy]

    def index
      @notices = TenderNotice.all.order('created_at ASC')
    end

    def show; end

    def new
      @notice = TenderNotice.new
    end

    def edit; end

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
      if @notice.update(notice_params)
        redirect_to tms_notice_url(@notice),
                    flash: { success: 'Tender Notice was successfully updated.' }
      else
        render :edit
      end
    end

    def destroy
      @notice.destroy
      redirect_to tms_notices_path,
                  flash: { success: 'Tender Notice was successfully destroyed.' }
    end

    private

    def set_notice
      @notice = TenderNotice.find_by(reference_token: params[:reference_token])
    end

    def notice_params
      params.require(:notice).permit(
        :reference_token, :title, :description, :specification,
        :terms_and_conditions, :opening_on_string, :closing_on_string
      )
    end
  end
end
