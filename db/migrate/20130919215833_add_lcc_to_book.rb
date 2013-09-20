class AddLccToBook < ActiveRecord::Migration
  def change
    add_column :books, :LCC, :string
  end
end
