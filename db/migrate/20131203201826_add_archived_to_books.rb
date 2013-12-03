class AddArchivedToBooks < ActiveRecord::Migration
  def change
    add_column :books, :archived, :boolean
  end
end
