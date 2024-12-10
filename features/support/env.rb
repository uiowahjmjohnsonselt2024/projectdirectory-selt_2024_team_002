# frozen_string_literal: true

require 'cucumber/rails'
require 'rspec/expectations'

Rails.application.routes.default_url_options[:host] = 'localhost:3000'

Capybara.register_driver :selenium_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  # Pass custom arguments here
  options.add_argument('--headless') # Run in headless mode
  options.add_argument('--disable-gpu') # Disable GPU
  options.add_argument('--window-size=1920,1080') # Set a default window size
  options.add_argument('--no-sandbox') # Avoid sandboxing issues
  options.add_argument('--disable-dev-shm-usage') # Fix some environments like Docker
  unless ENV['CHROME_USER_DATA_DIR'].nil?
    options.add_argument("--user-data-dir=#{ENV['CHROME_USER_DATA_DIR']}") # Fix some environments like Docker
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_selector = :css
Capybara.default_driver = :selenium_headless # Use Selenium with Chrome
Capybara.javascript_driver = :selenium_chrome # Use Selenium with Chrome for JS tests

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

Cucumber::Rails::Database.javascript_strategy = :truncation
