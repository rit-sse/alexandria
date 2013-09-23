class Strike < ActiveRecord::Base
  has_one :user, as: :patron
  has_one :user, as: :distributor

end
