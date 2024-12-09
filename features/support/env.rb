# frozen_string_literal: true

require 'cucumber/rails'
require 'rspec/expectations'

Rails.application.routes.default_url_options[:host] = 'localhost:3000'

Capybara.default_selector = :css
Capybara.default_driver = :selenium_chrome # Use Selenium with Chrome
Capybara.javascript_driver = :selenium_chrome # Use Selenium with Chrome for JS tests

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise 'You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it.'
end

Cucumber::Rails::Database.javascript_strategy = :truncation
