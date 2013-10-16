# The role model
class Role < ActiveRecord::Base
  has_many :users
end
