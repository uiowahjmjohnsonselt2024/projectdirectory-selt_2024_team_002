# frozen_string_literal: true

# this seeds our database for the int tests
Before do
  Rails.application.load_seed
end

at_exit do
  system('rails my:custom_feature_task') # Calls a rake task after all tests
end
