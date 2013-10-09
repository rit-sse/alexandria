class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end
    remove_column :users, :role, :string
    add_reference :users, :role, index: true
  end
end
