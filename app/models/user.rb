require 'bcrypt'
# User model
class User < ActiveRecord::Base
  include BCrypt
  # Only permit omniauth accounts
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  devise :database_authenticatable

  attr_accessor :password

  has_many :reservations
  has_many :books_reserved, through: :reservations, source: :book
  has_many :checkouts, foreign_key: :patron_id
  has_many :books_checked_out, through: :checkouts, source: :book
  has_many :strikes, foreign_key: :patron_id
  belongs_to :role

  before_save :default_values

  def barcode
    @barcode ||= Password.new(barcode_hash)
  end

  def barcode=(new_barcode)
    @barcode = Password.create(new_barcode)
    self.barcode_hash = @barcode
  end

  def default_values
    self.role ||= Role.find_by_name('patron')
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource = nil)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(user_name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20]
          )
    end
    user
  end
end
