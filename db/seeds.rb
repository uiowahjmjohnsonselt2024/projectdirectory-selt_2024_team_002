# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
worlds = [{ world_code: '12321', world_name: 'Test World 1', user_id_id: '1', is_public: true,
            max_player: '5', current_players: 0 },
          { world_code: '12322', world_name: 'Test World 2', user_id_id: '1', is_public: false,
            max_player: '5', current_players: 0 }]

worlds.each do |world|
  World.create!(world)
end

users = [{ email: 'admin@admin.com', password: 'AdminsAreTheBest1$', display_name: 'admin', available_credits: 0,
           plus_user: true }]

users.each do |user|
  User.create!(user)
end

# Create all items
items = [{ item_name: 'XP Boost', item_description: 'Boosts your XP by 25 points', price: 5, is_interactable: true},
         { item_name: 'Speed Potion', item_description: 'Lets you move past adjacent cells for no cost', price: 1, is_interactable: true},
         { item_name: '4 Leaf Clover', item_description: 'Increases your minigame luck', price: 10, is_interactable: true}]


items.each do |item|
  Item.create!(item)
end
