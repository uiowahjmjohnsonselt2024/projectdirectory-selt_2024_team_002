# features/support/hooks.rb
Before do
  puts "Seeding test data..."
  Rails.application.load_seed
end