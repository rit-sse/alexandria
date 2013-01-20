class Checkout < ActiveRecord::Base
  attr_accessible :book, :checked_in_at, :checked_out_at, :distributor, :user
end
