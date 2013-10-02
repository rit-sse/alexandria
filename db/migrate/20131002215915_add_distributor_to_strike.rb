class AddDistributorToStrike < ActiveRecord::Migration
  def change
    add_reference :strikes, :distributor, index: true
  end
end
