class AddUserIdToReservation < ActiveRecord::Migration
  def change
    add_reference :reservations, :user, index: true
  end
end
