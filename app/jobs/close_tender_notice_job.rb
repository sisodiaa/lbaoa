class CloseTenderNoticeJob < ApplicationJob
  queue_as :default

  def perform(reference_token)
    notice = TenderNotice.find_by(reference_token: reference_token)
    notice.under_review! if notice&.published?
  end
end
