class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.User :user
      t.User :distributor
      t.Book :book
      t.DateTime :checked_out_at
      t.DateTime :checked_in_at

      t.timestamps
    end
  end
end
