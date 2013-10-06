class FixTerribleBentiSpelling < ActiveRecord::Migration
  def change
    rename_column :reservations, :fuffiled, :fulfilled
  end
end
