class AddActiveToStrikes < ActiveRecord::Migration
  def change
    add_column :strikes, :active, :boolean, default: true
  end
end
