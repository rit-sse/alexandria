class CreateAuthorBooks < ActiveRecord::Migration
  def change
    drop_join_table :authors, :books
    create_table :author_books do |t|
      t.references :author, index: true
      t.references :book, index: true

      t.timestamps
    end
  end
end
