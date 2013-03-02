class RemoveAuthorFromBook < ActiveRecord::Migration
  def up
    remove_column :books, :author
  end

  def down
    add_column :books, :author, :string
  end
end
