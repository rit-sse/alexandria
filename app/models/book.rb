class Book < ActiveRecord::Base
  has_many :reservations
  has_and_belongs_to_many :authors
  has_one :google_book_data

  searchable do
    text :title, :ISBN, :authors
  end

  def as_json(options = {})
    json = super(options)
    json[:authors] = self.authors.as_json(only: [:first_name, :last_name, :middle_initial])
    json[:thumbnail] = self.google_book_data.img_thumbnail

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
    gb = GoogleBookData.arel_table
    all = GoogleBookData.where(gb[:description].not_eq(""))
    index = (rand(0..(all.count-1)))
    all[index].book
  end

  def self.add_by_isbn(isbn)
    results =  GoogleBooks.search("isbn:#{isbn}")
    book = Book.new
    book.ISBN = isbn
    if results.total_items > 0
      gb = results.first

      title = gb.title.split(":")
      book.title = title[0]
      book.subtitle = title[1] ? title[1] : ""

      author = gb.authors
      author ||= ""
      author.split(",").each do |i|
        book.authors << Author.find_or_create(i)
      end
      book.save
      gbook = GoogleBookData.book_from_isbn(book.ISBN)
      gbook.save

      gbook.book = book
      gbook.save
    end

    book.save
    book
  end

end
