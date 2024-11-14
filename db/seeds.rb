# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
users = [{:user_id => 1, :first_name => "Dev", :last_name => "Team", :email => "admin@admin.com", :password => "admin", :display_name => "admin"}]

users.each do |user|
  User.create!(user)
end