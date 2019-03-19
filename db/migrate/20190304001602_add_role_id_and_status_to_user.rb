class AddRoleIdAndStatusToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role_id, :integer, null: false
    add_column :users, :status, :integer, null: false, default: User::STATUS_NOT_VERIFIED
  end
end
