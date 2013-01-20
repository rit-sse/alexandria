class Book < ActiveRecord::Base
  attr_accessible :ISBN, :UUID, :author, :publish_date, :title
end
