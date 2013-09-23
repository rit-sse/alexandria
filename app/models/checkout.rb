class Checkout < ActiveRecord::Base
  after_initialize :default_values

  belongs_to :patron, class_name: "User", foreign_key: :patron_id
  belongs_to :distributor, class_name: "User", foreign_key: :distributor_id
  belongs_to :book

  delegate :title, to: :book
  delegate :user_name, to: :patron

  validates :checked_out_at, presence: true
  validate :unique_checkout

  def default_values
    self.checked_out_at ||= DateTime.now
  end

  def patron(who=nil)
    if who
      self.patron_id = who.id
    else
      if self.patron_id
        return User.find(self.patron_id)
      else
        return nil
      end
    end
  end

  def self.checked_out(book, patron)
    checkouts = Checkout.where(patron_id: patron.id, checked_in_at: nil).select do |i|
      i.book.id == book.id
    end

    !checkouts.empty?
  end

  def self.all_active
    Checkout.where(checked_in_at: nil)
  end

  def unique_checkout
    unless book.nil?
      book_checkouts = Checkout.all_active.where(book_id: book.id)
      book_checkouts = book_checkouts.where('id != ?', self.id)
      unless book_checkouts.empty?
        errors.add(:book, 'Cannot checkout an already checked out book.')
      end
    end
  end
end
