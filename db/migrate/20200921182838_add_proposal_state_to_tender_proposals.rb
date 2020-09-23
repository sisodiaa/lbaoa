class AddProposalStateToTenderProposals < ActiveRecord::Migration[6.0]
  def change
    add_column :tender_proposals, :proposal_state, :integer, null: false, default: 0
  end
end
