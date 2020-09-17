class CreateTenderProposals < ActiveRecord::Migration[6.0]
  def change
    create_table :tender_proposals do |t|
      t.string :name
      t.string :email
      t.text :remark
      t.uuid :token, null: false, default: 'uuid_generate_v4()'
      t.references :tender_notice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
