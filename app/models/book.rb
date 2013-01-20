class Book < ActiveRecord::Base
  attr_accessible :ISBN, :UUID, :author, :publish_date, :title
  belongs_to :checkout
  has_and_belongs_to_many :reservation
end
