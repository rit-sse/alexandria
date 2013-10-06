class Strike < ActiveRecord::Base
  belongs_to :patron, class_name: 'User'
  belongs_to :distributor, class_name: 'User'
end
