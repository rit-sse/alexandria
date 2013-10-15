# Checkout model
class Checkout < ActiveRecord::Base
  after_initialize :default_values

  belongs_to :patron, class_name: 'User'
  belongs_to :distributor, class_name: 'User'
  belongs_to :book

  delegate :title, to: :book
  delegate :user_name, to: :patron

  validates :checked_out_at, presence: true
  validate :unique_checkout
  validate :restricted_book

  def default_values
    self.checked_out_at ||= DateTime.now
    self.due_date ||= checked_out_at + Rails.configuration.checkout_period
  end

  def patron(who = nil)
    if who
      self.patron_id = who.id
    else
      if patron_id
        return User.find(patron_id)
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
      book_checkouts = book_checkouts.where('id != ?', id)
      unless book_checkouts.empty?
        errors.add(:book, 'Cannot checkout an already checked out book.')
      end
    end
  end

  def restricted_book
    if book.present? && book.restricted
      errors.add(:book, 'Book is restricted can not check out.')
    end
  end

  def overdue?
    DateTime.now > self.due_date && checked_in_at.blank?
  end

  def need_reminding?
    Date.today + 3.days == self.due_date.to_date && checked_in_at.blank?
  end

  def send_overdue
    if overdue?
      self.due_date += Rails.configuration.checkout_period
      save
      strike = Strike.new
      strike.patron = patron
      strike.distributor = distributor
      strike.save
      CheckoutMailer.overdue_book(self).deliver
    end
  end

  def send_reminder
    CheckoutMailer.reminder(self).deliver if need_reminding?
  end

  def self.send_mailers
    all.each do |checkout|
      checkout.send_overdue
      checkout.send_reminder
    end
  end
end
