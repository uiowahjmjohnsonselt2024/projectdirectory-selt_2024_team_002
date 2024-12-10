# frozen_string_literal: true

# this seeds our database for the int tests
Before do
  DatabaseCleaner.clean
  Rails.application.load_seed
end

at_exit do
  path = Rails.root.join('int_storage')
  puts 'cleaning out the integration storage test dir'
  system("cd #{path} && rm -rf *") # only rm rf if the cd was successfull
end
