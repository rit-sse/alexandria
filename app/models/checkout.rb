# Checkout model
class Checkout < ActiveRecord::Base

  scope :active, ->  { where(checked_in_at: nil) }
  scope :patron, -> patron { where(patron_id: patron) }
  scope :book, -> book { where(book_id: book) }
  scope :overdue, -> { all.select{ |x| x.overdue? } }

  after_initialize :default_values

  belongs_to :patron, class_name: 'User'
  belongs_to :distributor, class_name: 'User'
  belongs_to :distributor_check_in, class_name: 'User'
  belongs_to :book

  delegate :title, to: :book
  delegate :user_name, to: :patron

  validates :checked_out_at, :distributor_id, :patron_id, :book_id, presence: true
  validate :unique_checkout, on: :create
  validate :restricted_book
  validate :is_a_distributor
  validate :patron_not_banned
  validate :first_reservation, on: :create

  def default_values
    self.checked_out_at ||= DateTime.now
    self.due_date ||= checked_out_at + Rails.configuration.checkout_period
  end

  def self.checked_out(book, patron)
    checkouts = Checkout.where(patron_id: patron.id, checked_in_at: nil).select do |i|
      i.book.try(:id) == book.id
    end

    !checkouts.empty?
  end

  def self.all_active
    Checkout.where(checked_in_at: nil)
  end

  def unique_checkout
    unless book.nil?
      book_checkouts = Checkout.all_active.where(book_id: book.id)
      unless book_checkouts.empty?
        errors.add(:book, 'is already checked out.')
      end
    end
  end

  def restricted_book
    if book.present? && book.restricted
      errors.add(:book, 'is restricted can not check out.')
    end
  end

  def is_a_distributor
    unless !distributor.nil? and (distributor.distributor? or distributor.librarian?)
      errors.add(:distributor, 'is not a distributor or librarian.')
    end
  end

  def patron_not_banned
    errors.add(:patron, 'cannot checkout a book if banned') if patron.nil? or patron.banned
  end

  def first_reservation
    res = book.reservations.select{ |r| !r.fulfilled and !r.expired? }.sort!{|a,b| a.created_at <=> b.created_at }.first if book.present?
    unless res.nil? or res.user == patron
      errors.add(:someone, 'has already reserved this book.')
    end
  end

  def overdue?
    DateTime.now > self.due_date && checked_in_at.blank?
  end

  def need_reminding?
    Date.today + Rails.configuration.remind_before == self.due_date.to_date && checked_in_at.blank?
  end

  def send_overdue
    if overdue?
      self.due_date += Rails.configuration.checkout_period
      save
      strike = Strike.new
      strike.patron = patron
      strike.distributor = distributor
      strike.reason = Reason.find_by_message('Overdue book')
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
