class CheckoutMailer < ActionMailer::Base
  default from: "no-reply@kristen-mills.com"

  def overdue_book(checkout)
    @user = checkout.patron
    @book = checkout.book
    @checkout = checkout
    mail(to: @user.email, subject: 'You have a book overdue.')
  end
end
