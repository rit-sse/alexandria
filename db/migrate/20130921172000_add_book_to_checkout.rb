class AddBookToCheckout < ActiveRecord::Migration
  def change
    add_reference :checkouts, :book, index: true
    remove_reference :books, :checkout, index: true
  end
end
