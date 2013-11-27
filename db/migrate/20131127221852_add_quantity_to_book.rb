class AddQuantityToBook < ActiveRecord::Migration
  def change
    add_column :books, :quantity, :integer, default: 1
  end
end
