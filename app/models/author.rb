class Author < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :middle_initial
  has_and_belongs_to_many :book
end
