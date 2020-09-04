class CreateTenderNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :tender_notices do |t|
      t.string :reference_token, null: false
      t.string :title, null: false
      t.text :description
      t.text :specification
      t.text :terms_and_conditions
      t.datetime :published_at
      t.datetime :opening_on
      t.datetime :closing_on
      t.integer :notice_state, null: false, default: 0
      t.integer :publication_state, null: false, default: 0

      t.timestamps
    end

    add_index :tender_notices, :reference_token, unique: true
  end
end
