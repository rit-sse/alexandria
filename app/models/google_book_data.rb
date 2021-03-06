require 'googlebooks'
# Google Book data model
class GoogleBookData < ActiveRecord::Base
  belongs_to :book

  def self.book_from_isbn(results)
    GoogleBookData.new(
        description:   '',
        img_thumbnail: '',
        img_small:     '',
        img_medium:    '',
        img_large:     '',
        preview_link:  ''
      ).set_google_book(results)
  end

  def update_data(isbn = book.isbn)
    if ENV['ALEXANDRIA_SIMPLE'].blank?
      results = GoogleBooks.search("isbn:#{isbn}")
    else
      results = GoogleBooks.search("isbn:#{isbn}", { api_key: ENV['ALEXANDRIA_SIMPLE'] })
    end

    set_google_book(results)

    self
  end

  def set_google_book(results)
    if results.total_items > 0
      google_book = results.first
      self.description   = google_book.description.to_s
      self.img_thumbnail = google_book.image_link(zoom: 5).to_s
      self.img_small     = google_book.image_link.to_s
      self.img_medium    = google_book.image_link(zoom: 2).to_s
      self.img_large     = google_book.image_link(zoom: 3).to_s
      self.preview_link  = google_book.preview_link.to_s
    end
    self
  end

  def self.update_all_null
    GoogleBookData.where(description: '').each { |i| i.update_data.save }
  end

end
