class AddSelectionReasonToTenderNotices < ActiveRecord::Migration[6.0]
  def change
    add_column :tender_notices, :selection_reason, :text
  end
end
