class ChangeForeignKeyForPosts < ActiveRecord::Migration[6.0]
  def change
    rename_column :posts, :department_id, :category_id
  end
end
