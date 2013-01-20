class AddUserIdToCheckout < ActiveRecord::Migration
  def change
    add_column :checkouts, :patron_id, :integer
    add_column :checkouts, :distributor_id, :integer
  end
end
