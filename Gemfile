source 'https://rubygems.org'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'compass-rails'
  gem 'bootstrap-sass-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'handlebars_assets'
end

gem 'jquery-rails'

# Test-related gems
group :development, :test do
  gem 'therubyracer'
  gem 'libv8', '~> 3.11.8'


  gem 'rspec'
  gem 'webrat'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'cucumber-rails', :require => false

  # database_cleaner is not required, but highly recommended
  gem 'database_cleaner'

  # Jenkins unit test formatting
  gem 'rspec_junit_formatter'

  #for search
  gem 'sunspot_solr'

  # Make error checking/viewing less horrible
  gem "better_errors"
  gem "binding_of_caller"
end

group :production do
 gem 'pg'
end

gem "haml-rails"

#for search
gem 'sunspot_rails'
gem 'progress_bar'

#for authentication
gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'

#for google books
gem 'googlebooks'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
