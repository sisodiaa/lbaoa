class RenameDepartmentToCategory < ActiveRecord::Migration[6.0]
  def change
    rename_table :departments, :categories
  end
end
