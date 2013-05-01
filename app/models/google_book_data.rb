require 'google_books'

class GoogleBookData < ActiveRecord::Base
  attr_accessible :book_id, :description, :img_large, :img_medium, :img_small, :img_thumbnail, :preview_link
  has_one :book

  def self.book_from_isbn(isbn)
  	begin
	  	google_books =  GoogleBooks::API.search("isbn:#{isbn}").first
	  	return GoogleBookData.new( 
	  		description:   google_book.description,
	  		img_thumbnail: google_book.covers[:thumbnail],
	  		img_small:     google_book.covers[:small],
	  		img_medium:    google_book.covers[:medium],
	  		img_large:     google_book.covers[:large],
	  		preview_link:  google_book.preview_link
	  	)
  	rescue
  		return GoogleBookData.new( 
	  		description:   "",
	  		img_thumbnail: "",
	  		img_small:     "",
	  		img_medium:    "",
	  		img_large:     "",
	  		preview_link:  ""
	  	)
  	end

  end
end
