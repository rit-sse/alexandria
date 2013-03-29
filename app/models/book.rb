require 'google_books'

class Book < ActiveRecord::Base
  attr_accessible :ISBN, :UUID, :publish_date, :title
  belongs_to :checkout
  has_and_belongs_to_many :reservation
  has_and_belongs_to_many :author

  @google_book = nil
  searchable do
    text :title, :ISBN, :author
  end

  def google_book
    if not @google_book
  	 @google_book = GoogleBooks::API.search("isbn:#{self.ISBN}").first
    end
    return @google_book
  end
  
end
