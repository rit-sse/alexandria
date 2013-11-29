# Book model
class Book < ActiveRecord::Base
  include Lccable
  after_initialize :default_values
  has_many :reservations
  has_many :author_books
  has_many :authors, through: :author_books
  has_one :google_book_data
  has_many :checkouts

  searchable do
    text :title, :isbn
    text :authors do
      authors.map{ |author| author.full_name }
    end
  end

  validates :lcc, uniqueness: true, allow_blank: true
  validates :isbn, presence: true

  def default_values
    self.restricted ||= false
    self.lcc ||= ''
  end

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

    checkouts.count == quantity
  end

  def active_checkout patron
    checkouts.each do |checkout|
      return checkout if checkout.checked_in_at.nil? and checkout.patron == patron
    end
    nil
  end

  def reserved?
    Reservation.where(book_id: id, fulfilled: false).any?
  end

  def self.featured_book
    gb = GoogleBookData.arel_table
    all = GoogleBookData.where(gb[:description].not_eq(''))
    all.sample.book
  end

  def self.add_by_isbn(isbn)
    isbn = "0#{isbn}" if isbn.size == 9
    if isbn.size == 10
      checksum = isbn13_checksum_digit("978#{isbn.chop}")
      isbn = "978#{isbn.chop}#{checksum}"
    end
    if ENV['ALEXANDRIA_SIMPLE'].blank?
      results = GoogleBooks.search("isbn:#{isbn}")
    else
      results = GoogleBooks.search("isbn:#{isbn}", { api_key: ENV['ALEXANDRIA_SIMPLE'] })
    end
    book = Book.new(isbn: isbn)
    book.get_lcc
    gbook = GoogleBookData.new(
        description:   '',
        img_thumbnail: '',
        img_small:     '',
        img_medium:    '',
        img_large:     '',
        preview_link:  ''
      )
    if results.total_items > 0
      book.set_book(results.first)
      gbook = GoogleBookData.book_from_isbn(results)
    end
    gbook.book = book
    gbook.save
    book.save
    book
  end

  def self.isbn_checksum(isbn_string)
    digits = isbn_string.split(//).map(&:to_i)
    transformed_digits = digits.each_with_index.map do |digit, digit_index|
      digit_index.modulo(2).zero? ? digit : digit*3
    end
    sum = transformed_digits.reduce(:+)
  end

  def self.isbn13_checksum_digit(isbn12)
    checksum = isbn_checksum(isbn12)
    (10 - checksum.modulo(10))%10
  end

  def set_book(gb)
    title = gb.titles_array
    self.title = title[0]
    self.subtitle = title[1] || ''
    self.publish_date = gb.published_date

    author_array = gb.authors_array
    author_array.each do |i|
      authors << Author.find_or_create(i)
    end
  end

end