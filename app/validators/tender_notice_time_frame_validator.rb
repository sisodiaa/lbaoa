class TenderNoticeTimeFrameValidator < ActiveModel::Validator
  def validate(record)
    error_for_opening_on(record)
    error_for_closing_on(record)
    error_for_invalid_timeframe(record)
  end

  private

  def error_for_opening_on(record)
    record.errors[:opening_on] << 'is required for publishing the notice' if record.opening_on.present?
  end

  def error_for_closing_on(record)
    record.errors[:closing_on] << 'is required for publishing the notice' if record.closing_on.present?
  end

  def error_for_invalid_timeframe(record)
    record.errors[:opening_on] << 'should be before closing on' if invalid_timeframe?(record)
  end

  def invalid_timeframe?(record)
    record.opening_on.present? &&
      record.closing_on.present? &&
      record.opening_on >= record.closing_on
  end
end
