# Checkout model
class Checkout < ActiveRecord::Base
  after_initialize :default_values

  belongs_to :patron, class_name: 'User'
  belongs_to :distributor, class_name: 'User'
  belongs_to :book

  delegate :title, to: :book
  delegate :user_name, to: :patron

  validates :checked_out_at, :distributor_id, :patron_id, presence: true
  validate :unique_checkout
  validate :restricted_book
  validate :is_a_distributor

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

  def is_a_distributor
    unless [Role.find_by_name('librarian'), Role.find_by_name('distributor')].include?(distributor.role)
      errors.add(:distributor, 'User is not a distributor or librarian')
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
