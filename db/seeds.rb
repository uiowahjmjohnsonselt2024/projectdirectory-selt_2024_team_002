# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
worlds = [{ world_code: '12321', world_name: 'Test World 1', user_id: '1', is_public: true,
            max_player: '5', current_players: 0 },
          { world_code: '12322', world_name: 'Test World 2', user_id: '1', is_public: false,
            max_player: '5', current_players: 0 }]

worlds.each do |world|
  World.create!(world)
end

users = [{ id: 1, email: 'admin@admin.com', password: 'AdminsAreTheBest1$', display_name: 'admin', available_credits: 0,
           plus_user: true }]

users.each do |user|
  User.create!(user)
end

user_worlds = [{ world: World.where(world_name: 'Test World 2').first, user: User.find_user_by_display_name('admin') },
               { world: World.where(world_name: 'Test World 1').first, user: User.find_user_by_display_name('admin') }]
user_worlds.each do |user_world|
  UserWorld.create!(user_world)
end