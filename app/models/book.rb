require 'google_books'

class Book < ActiveRecord::Base
  attr_accessible :ISBN, :UUID, :publish_date, :title, :subtitle
  belongs_to :checkout
  has_and_belongs_to_many :reservation
  has_and_belongs_to_many :author

  @google_book = nil
  searchable do
    text :title, :ISBN, :author
  end

  def google_book
    # 

    begin
      return GoogleBooks::API.search("isbn:#{self.ISBN}").first      
      Rails.cache.write(self, google_book)
    rescue
      return nil
    end
  end

  def thumbnail
    if Rails.cache.read(self)
       return Rails.cache.read(self)
    end

    g_book = google_book
    thumbnail = ""
    
    if g_book
      thumbnail = g_book.covers[:thumbnail]
    end
    
    Rails.cache.write(self, thumbnail)
    return thumbnail

  end

  def as_json(options = {})
    json = super(options)
    json[:authors] = self.author.as_json(only: [:first_name, :last_name, :middle_initial])
    json[:thumbnail] = self.thumbnail

    json
  end
  
end
