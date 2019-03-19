class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections, id: false do |t|
      t.column :id, :primary_key, limit: 4, null: false, unsigned: true
      t.string :action_key, limit: 250, null: false
      t.string :name, limit: 500, null: false
      t.string :desc, limit: 500
      t.integer :parent_id, limit: 4, unsigned: true, index: true
      t.integer :lft, limit: 4, unsigned: true, index: true
      t.integer :rgt, limit: 4, unsigned: true, index: true
      t.integer :depth, limit: 4, null: false, unsigned: true, default: 0
      t.integer :children_count, null: false, unsigned: true, default: 0

      t.integer :is_display, limit: 1, default: 0, null: false, unsigned: true
      t.timestamps null: false
    end
  end
end
