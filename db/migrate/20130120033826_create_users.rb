class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_name
      t.boolean :banned
      t.string :role

      t.timestamps
    end
  end
end
