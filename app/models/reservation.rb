class Reservation < ActiveRecord::Base
  attr_accessible :book, :expires_at, :fuffiled, :reserve_at, :user
end
