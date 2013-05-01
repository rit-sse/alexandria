class Book < ActiveRecord::Base
  attr_accessible :ISBN, :UUID, :publish_date, :title, :subtitle
  has_many :reservation
  has_and_belongs_to_many :author
  has_one :google_book_data

  searchable do
    text :title, :ISBN, :author
  end

  def as_json(options = {})
    json = super(options)
    json[:authors] = self.author.as_json(only: [:first_name, :last_name, :middle_initial])
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
    all = Book.includes(:google_book_data).where("google_book_data.description IS NOT ''")
    index = (rand(0..(all.count-1)))
    all[index]
  end



end
