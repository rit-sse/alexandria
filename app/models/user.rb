class User < ActiveRecord::Base
  attr_accessible :banned, :role, :user_name
  
  has_many :reservations
  has_many :checkouts
end
