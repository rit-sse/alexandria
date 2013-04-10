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
      begin
    	 @google_book = GoogleBooks::API.search("isbn:#{self.ISBN}").first
      rescue
        @google_book = nil
      end
    end
    return @google_book
  end

  def as_json(options = {})
    json = super(options)
    json[:authors] = self.author.as_json(only: [:first_name, :last_name, :middle_initial])
    json
  end
  
end
