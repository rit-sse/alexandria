class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :ISBN
      t.string :title
      t.string :author
      t.Date :publish_date
      t.string :UUID

      t.timestamps
    end
  end
end
