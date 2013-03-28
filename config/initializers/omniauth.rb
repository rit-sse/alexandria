# CONTACT DORRENE FOR KEYS FOR OAUTH. IF I GIVE THEM TO YOU AND YOU CHECK THEM IN I WILL BE EXTREMELY UPSET.
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "app-id", "app-private"
end