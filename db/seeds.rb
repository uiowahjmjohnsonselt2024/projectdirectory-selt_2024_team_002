# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

worlds = [{:world_code => "12321", :world_name => "Test World 1", :user_id => "0", :is_public => true, :max_player => "5"},
          {:world_code => "12322", :world_name => "Test World 2", :user_id => "0", :is_public => false, :max_player => "5"}]

worlds.each do |world|
  World.create!(world)
end