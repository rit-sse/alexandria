class ChangeDescriptionInGoogleBookData < ActiveRecord::Migration
  def up
    change_column :google_book_data, :description, :text, :limit => nil
  end

  def down
  end
end
