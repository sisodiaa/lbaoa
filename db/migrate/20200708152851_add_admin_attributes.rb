class AddAdminAttributes < ActiveRecord::Migration[6.0]
  def change
    change_table :admins, bulk: true do |t|
      t.string :first_name
      t.string :last_name
      t.integer :affiliation, null: false, default: 0
      t.integer :status, null: false, default: 0
    end
  end
end
