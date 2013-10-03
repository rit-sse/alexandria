class CheckoutMailer < ActionMailer::Base
  default from: "from@example.com"

  def reminder(checkout)
    @user = checkout.patron
    @book = checkout.book
    @checkout = checkout
    mail(to: @user.email, subject: 'You have a book due soon.')
  end
  def overdue_book(checkout)
    @user = checkout.patron
    @book = checkout.book
    @checkout = checkout
    mail(to: @user.email, subject: 'You have a book overdue.')
  end
end
