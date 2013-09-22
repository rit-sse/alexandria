class AddIndexes < ActiveRecord::Migration
  def change
    # Even if we don't need to use these indexes directly, they can improve the
    # performance of sql queries.
    add_index :books, :checkout_id
    add_index :checkouts, :patron_id
    add_index :checkouts, :distributor_id
    add_index :google_book_data, :book_id
    add_index :reservations, :user_id
    add_index :reservations, :book_id
  end
end
