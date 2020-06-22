class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.integer :publication_state, null: false, default: 0
      t.integer :visibility_state, null: false, default: 0
      t.references :department, null: false, foreign_key: true

      t.timestamps
    end
  end
end
