class AddUnavailableToBooks < ActiveRecord::Migration
  def change
    add_column :books, :unavailable, :boolean
  end
end
