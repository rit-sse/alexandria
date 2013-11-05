set :output, 'log/cron.log'
set :environment, :production

every :day, at: '12:00 am' do
  runner 'Checkout.send_mailers'
end
