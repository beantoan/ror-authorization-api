class CreateChildSections < ActiveRecord::Migration[5.2]
  def change
    create_table :child_sections, id: false do |t|
      t.column :id, :primary_key, limit: 4, null: false, unsigned: true
      t.integer :section_id, limit: 4, null: false, unsigned: true
      t.integer :child_section_id, limit: 4, null: false, unsigned: true
      t.timestamps null: false
    end
  end
end
