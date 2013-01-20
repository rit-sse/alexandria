class User < ActiveRecord::Base
  attr_accessible :banned, :role, :user_name
end
