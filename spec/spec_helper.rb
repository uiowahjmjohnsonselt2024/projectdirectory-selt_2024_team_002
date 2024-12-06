# frozen_string_literal: true

require 'simplecov'
# require 'rails_helper'

SimpleCov.start 'rails' do
  SimpleCov.add_filter 'app/helper' # all files here are http orchestrators to call other services
  SimpleCov.add_filter 'app/mailers' # rails generated directory
  SimpleCov.add_filter 'app/jobs' # this is a crude event queue
  SimpleCov.add_filter 'app/controllers/application_controller.rb' # rails generated file
  SimpleCov.add_filter 'app/models/application_record.rb' # rails generated file
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
