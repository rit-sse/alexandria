class AddBarcodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :barcode_hash, :string
  end
end
