class CreateReasons < ActiveRecord::Migration
  def change
    create_table :reasons do |t|
      t.string :message

      t.timestamps
    end

    add_reference :strikes, :reason, index: true
    rename_column :strikes, :message, :other_info
  end
end
