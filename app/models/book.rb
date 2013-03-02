class Book < ActiveRecord::Base
  attr_accessible :ISBN, :UUID, :publish_date, :title
  belongs_to :checkout
  has_and_belongs_to_many :reservation
  has_and_belongs_to_many :author
end
