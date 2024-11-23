# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'

gem "puma"
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'ffi'
gem 'rubocop'
gem 'sdoc', group: :doc

gem 'activestorage'

# Use ActiveModel has_secure_password
gem 'bcrypt'

# verifys email formating. Can also verify that the mail server exists thru dns
gem 'rubocop-rake'
gem 'valid_email2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'rspec'
  gem 'rspec-rails'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3', '2.0.4'
  gem 'rails-controller-testing'
  gem 'dotenv-rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'simplecov'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # gem 'sqlite', '=1.0.2'
end

group :test do
  gem 'rspec-expectations'
end

group :production do
  gem 'pg', '~> 0.20.0' # for Heroku deployment
  gem 'rails_12factor'
end
