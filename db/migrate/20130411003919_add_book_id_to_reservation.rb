class AddBookIdToReservation < ActiveRecord::Migration
  def change
    add_reference :reservations, :book, index: true
  end
end
