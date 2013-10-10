class AddRestrictionsToBooks < ActiveRecord::Migration
  def change
    add_column :books, :restricted, :boolean
  end
end
