class Strike < ActiveRecord::Base
  attr_accessible :message
  has_one :user, :as => :patron
  has_one :user, :as => :distributor

end
