class AddCheckInDistributorToCheckout < ActiveRecord::Migration
  def change
    add_reference :checkouts, :distributor_check_in, index: true
  end
end
