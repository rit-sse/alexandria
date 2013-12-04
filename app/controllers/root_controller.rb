# Homepage controller
class RootController < ApplicationController
  skip_authorization_check
  def index
    @books = Book.all.sample(3)
  end
end
