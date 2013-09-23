class AuthorsBooks < ActiveRecord::Migration
  def change
  	create_join_table :authors, :books
  end
end
