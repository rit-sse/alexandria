class AddCheckoutToBook < ActiveRecord::Migration
  def change
    add_reference :books, :checkout, index: true
  end
end
