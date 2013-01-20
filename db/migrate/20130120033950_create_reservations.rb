class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.datetime :reserve_at
      t.boolean :fuffiled
      t.datetime :expires_at

      t.timestamps
    end
  end
end
