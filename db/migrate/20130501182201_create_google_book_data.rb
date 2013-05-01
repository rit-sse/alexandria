class CreateGoogleBookData < ActiveRecord::Migration
  def change
    create_table :google_book_data do |t|
      t.string :description
      t.string :preview_link
      t.string :img_thumbnail
      t.string :img_small
      t.string :img_large
      t.string :img_medium
      t.string :img_large
      t.integer :book_id

      t.timestamps
    end
  end
end
