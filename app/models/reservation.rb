# Reservation model
class Reservation < ActiveRecord::Base
  after_initialize :default_values
  belongs_to :user
  belongs_to :book

  delegate :title, to: :book
  delegate :user_name, to: :user

  validates :book_id, :user_id, presence: true
  validate :cannot_have_2_reservations_on_1_book
  validate :user_not_banned

  def expired?
    DateTime.now > expires_at
  end

  def default_values
    self.expires_at ||= DateTime.now + Rails.configuration.reservation_period
    self.fulfilled ||= false
    self.reserve_at ||= DateTime.now
  end

  def cannot_have_2_reservations_on_1_book
    unless user.nil? || book.nil?
      reservations = Reservation.where(user_id: user.id, book_id: book.id, fulfilled: false)
      reservations = reservations.delete_if { |x| x.id == id }
      unless reservations.empty?
        errors.add(:user, 'Cannot have multiple reservations on one book.')
      end
    end
  end

  def user_not_banned
    errors.add(:user, 'cannot reserve a book if banned') if user.nil? or user.banned
  end

  def self.has_reservation(book, user)
    !Reservation.where(user_id: user.id, book_id: book.id, fulfilled: false).empty?
  end

  def self.get_reservation(book, user)
    reservations = Reservation.where(user_id: user.id, book_id: book.id, fulfilled: false)
    if reservations.empty?
      return nil
    else
      return reservations.first
    end
  end
end
