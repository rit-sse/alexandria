require 'google_books'

class Book < ActiveRecord::Base
  attr_accessible :ISBN, :UUID, :publish_date, :title, :subtitle
  has_many :reservation
  has_and_belongs_to_many :author
  belongs_to :google_book_data

  @google_book = nil
  searchable do
    text :title, :ISBN, :author
  end

  def google_book
    if @google_book
      return @google_book
    end

    begin
      @google_book =  GoogleBooks::API.search("isbn:#{self.ISBN}").first      
      Rails.cache.write(self, google_book)
    rescue
      return nil
    end

    return @google_book
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
  

  def checked_out?
    checkouts = Checkout.where(checked_in_at: nil).select do |i|
      i.book.id == self.id
    end

    checkouts.any?
  end


  def reserved?
    Reservation.where(book_id: self.id, fuffiled: false).any?
  end

  def self.featured_book
    book = nil

    while !book
      book = Book.find(rand(1..(Book.count-1)))
      book = nil if book.google_book == nil
    end

    book
  end



end
