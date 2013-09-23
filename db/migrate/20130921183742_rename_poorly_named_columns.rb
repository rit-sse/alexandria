class RenamePoorlyNamedColumns < ActiveRecord::Migration
  def change
    rename_column :books, :LCC, :lcc
    rename_column :books, :ISBN, :isbn
  end
end
