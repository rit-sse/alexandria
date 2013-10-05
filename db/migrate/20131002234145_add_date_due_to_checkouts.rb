class AddDateDueToCheckouts < ActiveRecord::Migration
  def change
    add_column :checkouts, :due_date, :datetime
  end
end
