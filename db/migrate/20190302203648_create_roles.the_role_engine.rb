# This migration comes from the_role_engine (originally 20111025025129)
class CreateRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :roles do |t|
      t.string :name,        null: false, unique: true
      t.string :title,       null: false, unique: true
      t.text   :description
      t.text   :the_role,    null: false

      t.timestamps
    end
  end
end
