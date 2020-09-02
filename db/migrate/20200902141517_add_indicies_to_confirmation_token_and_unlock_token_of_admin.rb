class AddIndiciesToConfirmationTokenAndUnlockTokenOfAdmin < ActiveRecord::Migration[6.0]
  def change
    add_index :admins, :confirmation_token,   unique: true
    add_index :admins, :unlock_token,         unique: true
  end
end
