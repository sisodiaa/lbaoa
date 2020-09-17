module Tender
  class NoticesController < ApplicationController
    include Pagy::Backend

    def index
      @pagy, @tender_notices = pagy(
        published_tender_notices.order(published_at: :desc), items: 10
      )
    end

    def show
      @notice = TenderNotice.find_by(reference_token: params[:reference_token])
    end

    private

    def published_tender_notices
      TenderNotice.published.try!(params[:status].to_sym)
    rescue NoMethodError
      TenderNotice.none
    end
  end
end
