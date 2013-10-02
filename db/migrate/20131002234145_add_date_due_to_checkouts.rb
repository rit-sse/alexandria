class AddDateDueToCheckouts < ActiveRecord::Migration
  def change
    add_column :checkouts, :date_due, :datetime
  end
end
