class Book < ActiveRecord::Base
  include Lccable
  has_many :reservations
  has_many :author_books
  has_many :authors, through: :author_books
  has_one :google_book_data
  has_many :checkouts

  searchable do
    text :title, :isbn, :authors
  end

  validates :isbn, :lcc, uniqueness: true, allow_blank: true

  def as_json(options = {})
    json = super(options)
    json[:authors] = authors.as_json(only: [:first_name, :last_name, :middle_initial])
    json[:thumbnail] = google_book_data.img_thumbnail

    json
  end

  def checked_out?
    checkouts = Checkout.where(checked_in_at: nil).select do |i|
      i.book.id == id
    end

    checkouts.any?
  end

  def reserved?
    Reservation.where(book_id: id, fuffiled: false).any?
  end

  def self.featured_book
    gb = GoogleBookData.arel_table
    all = GoogleBookData.where(gb[:description].not_eq(''))
    all.sample.book
  end

  def self.add_by_isbn(isbn)
    results =  GoogleBooks.search("isbn:#{isbn}")
    book = Book.new(isbn: isbn)
    if results.total_items > 0
      book.set_book(results.first)
      gbook = GoogleBookData.book_from_isbn(book.isbn)
      gbook.book = book
      gbook.save
    end
    book.save
    book
  end

  def set_book(gb)
    title = gb.title.split(':')
    self.title = title[0]
    self.subtitle = title[1] ? title[1].strip : ''
    self.publish_date = gb.published_date
    get_lcc

    author = gb.authors
    author ||= ""
    author.split(", ").each do |i|
      authors << Author.find_or_create(i)
    end
  end

end
