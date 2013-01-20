class Checkout < ActiveRecord::Base
  attr_accessible :checked_in_at, :checked_out_at
  belongs_to :user, :foreign_key => :patron_id
  belongs_to :user, :foreign_key => :distributor_id
end
