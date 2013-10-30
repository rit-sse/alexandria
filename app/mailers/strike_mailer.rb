# Mailers for checkout related things
class StrikeMailer < ActionMailer::Base
  default from: 'from@example.com'

  def strike(strike)
    @strike = strike
    @user = strike.patron
    mail(to: @user.email, subject: 'You have recieved a strike.')
  end

  def banned(user)
    @user = user
    mail(to: user.email, subject: 'You have been banned.')
  end
end
