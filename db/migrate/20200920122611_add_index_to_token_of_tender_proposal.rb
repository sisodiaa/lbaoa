class AddIndexToTokenOfTenderProposal < ActiveRecord::Migration[6.0]
  def change
    add_index :tender_proposals, :token, unique: true
  end
end
