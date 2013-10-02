class RootController < ApplicationController
  def index
    if not Book.all.empty?
      @books = (0..2).to_a.map do |i|
        Book.featured_book
      end
      @books = @books.select{|i| !i.nil?}
    else
      @books = Array.new
    end
  end
end
