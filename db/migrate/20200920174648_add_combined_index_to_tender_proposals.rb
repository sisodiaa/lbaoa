class AddCombinedIndexToTenderProposals < ActiveRecord::Migration[6.0]
  def change
    add_index :tender_proposals, [:email, :tender_notice_id], unique: true
  end
end
