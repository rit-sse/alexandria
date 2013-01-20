class AddCheckoutToBook < ActiveRecord::Migration
  def change
    add_column :books, :checkout_id, :integer
  end
end
