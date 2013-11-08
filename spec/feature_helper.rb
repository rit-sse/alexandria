include Warden::Test::Helpers

module FeatureHelpers
  def login
    user = FactoryGirl.create(:librarian)
    login_as user, scope: :user
    user
  end
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
