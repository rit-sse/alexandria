class CreateStrikes < ActiveRecord::Migration
  def change
    create_table :strikes do |t|
      t.User :user
      t.User :distributor
      t.String :message

      t.timestamps
    end
  end
end
