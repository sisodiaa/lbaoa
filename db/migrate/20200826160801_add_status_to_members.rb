class AddStatusToMembers < ActiveRecord::Migration[6.0]
  def change
    add_column :members, :status, :integer, null: false, default: 0
  end
end
