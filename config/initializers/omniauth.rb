# CONTACT KRISTEN FOR KEYS FOR OAUTH. IF I GIVE THEM TO YOU AND YOU CHECK THEM IN I WILL BE EXTREMELY UPSET.
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "464103650550.apps.googleusercontent.com", "g1uuwy4CnnxibTd-wUXq4Uge"
end