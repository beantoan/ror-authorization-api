class CreateRolesSections < ActiveRecord::Migration[5.2]
  def change
    create_table :roles_sections , id: false do |t|
      t.column :id, :primary_key, limit: 4, null: false, unsigned: true
      t.integer :role_id, limit: 4, null: false, unsigned: true
      t.integer :section_id, limit: 4, null: false, unsigned: true
      t.integer :is_moderator, limit: 1, default: 0, null: false, unsigned: true
    end

    add_index :roles_sections, [:role_id, :section_id], unique: true
  end
end
