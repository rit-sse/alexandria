class AddBookIdToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :book_id, :integer
  end
end
