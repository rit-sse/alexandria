set :output, 'log/cron.log'
set :environment, :development

every :day, at: '12:00 am' do
  runner 'Checkout.send_overdue'
end
