class CreateStrikes < ActiveRecord::Migration
  def change
    create_table :strikes do |t|
      t.string :message

      t.timestamps
    end
  end
end
