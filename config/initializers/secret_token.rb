# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Alexandria::Application.config.secret_key_base = if Rails.env.development? or Rails.env.test? 
  '19683d132e26d08a7fbce0a0b8d83a0d10fa15d1a3cfbce64c8a8f776fa1e6422655b284731b7c3c22de42e075260a388cf021e6e4ae55e0eb854127100943ba'
else
  ENV['SECRET_TOKEN']
end