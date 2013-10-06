class Reservation < ActiveRecord::Base
  after_initialize :default_values
  belongs_to :user
  belongs_to :book

  delegate :title, to: :book
  delegate :user_name, to: :user

  validates :book_id, :user_id, presence: true
  validate :cannot_have_2_reservations_on_1_book

  def default_values
    self.expires_at ||= DateTime.now + 1.week
    self.fuffiled ||= false
    self.reserve_at ||= DateTime.now
  end

  def cannot_have_2_reservations_on_1_book
    unless user.nil? || book.nil?
      reservations = Reservation.where(user_id: user.id, book_id: book.id, fuffiled: false)
      reservations = reservations.delete_if { |x| x.id == id }
      unless reservations.empty?
        errors.add(:user_id, 'cannot have multiple reservations on one book')
      end
    end
  end

  def self.has_reservation(book, user)
    !Reservation.where(user_id: user.id, book_id: book.id, fuffiled: false).empty?
  end

  def self.get_reservation(book, user)
    reservations = Reservation.where(user_id: user.id, book_id: book.id, fuffiled: false)
    if reservations.empty?
      return nil
    else
      return reservations.first
    end
  end
end
