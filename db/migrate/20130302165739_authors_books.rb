class AuthorsBooks < ActiveRecord::Migration
  def up
  	create_table 'authors_books', :id => false do |t|
  		t.column :author_id, :integer
  		t.column :book_id, :integer
  	end
  end

  def down
  end
end
