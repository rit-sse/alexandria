class Reservation < ActiveRecord::Base
  attr_accessible :expires_at, :fuffiled, :reserve_at
  belongs_to :user
  has_one :book
end
