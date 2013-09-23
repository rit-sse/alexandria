class AddUserIdToCheckout < ActiveRecord::Migration
  def change
    add_reference :checkouts, :patron, index: true
    add_reference :checkouts, :distributor, index: true
  end
end
