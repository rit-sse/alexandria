class RootController < ApplicationController
  def index
    @books = (0..2).to_a.map do |i|
      Book.featured_book
    end
    @books = @books.find_all{|i| i != nil}
  end
end
