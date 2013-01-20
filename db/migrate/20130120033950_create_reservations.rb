class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.User :user
      t.Book :book
      t.DateTime :reserve_at
      t.boolean :fuffiled
      t.DateTime :expires_at

      t.timestamps
    end
  end
end
