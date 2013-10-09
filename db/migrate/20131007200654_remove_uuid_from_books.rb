class RemoveUuidFromBooks < ActiveRecord::Migration
  def change
    remove_column :books, :UUID, :string
  end
end
