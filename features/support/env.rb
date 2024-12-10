# frozen_string_literal: true

require 'cucumber/rails'
require 'rspec/expectations'

Rails.application.routes.default_url_options[:host] = 'localhost:3000'

Capybara.default_selector = :css

# Dynamically configure Selenium with a unique user-data-dir for every test session
Capybara.register_driver(:selenium_chrome) do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  # Create a unique directory for every Chrome session to prevent conflicts
  options.add_argument("--user-data-dir=#{Dir.mktmpdir}")
  options.add_argument('--headless') # Use headless mode if you want tests without a visible browser
  options.add_argument('--disable-gpu')
  options.add_argument('--window-size=1920,1080')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.javascript_driver = :selenium_chrome

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

Cucumber::Rails::Database.javascript_strategy = :truncation
