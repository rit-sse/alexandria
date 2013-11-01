# Contact Kristen for the keys. Please don't check them in.
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['ALEXANDRIA_KEY'], ENV['ALEXANDRIA_SECRET']
end
