# frozen_string_literal: true

worlds = [{ world_code: '12321', world_name: 'Test World 1', user_id: '1', is_public: true,
            max_player: '5', current_players: 0 },
          { world_code: '12322', world_name: 'Test World 2', user_id: '1', is_public: false,
            max_player: '5', current_players: 0 }]

worlds.each do |world|
  World.create!(world)
end

users = [{ email: 'admin@admin.com', password: 'AdminsAreTheBest1$', display_name: 'admin', available_credits: 100000,
           plus_user: true },
         { email: 'test@test.com', password: 'AdminsAreTheBest1$', display_name: 'test', available_credits: 0,
           plus_user: true },
         { email: 'seltgrader@nowhere.com', password: 'selt.is.#1BEST.course', display_name: 'seltgrader', available_credits: 1000, plus_user: false }
]

users.each do |user|
  User.create!(user)
end

user_worlds = [{ world: World.where(world_name: 'Test World 2').first, user: User.find_user_by_display_name('admin') },
               { world: World.where(world_name: 'Test World 1').first, user: User.find_user_by_display_name('admin') }]
user_worlds.each do |user_world|
  UserWorld.create!(user_world)
end
messages = [
  { world_id: World.all.first.id, user_id: User.all.first.id, message: 'Welcome to Test World 1!', created_at: Time.now, updated_at: Time.now },
  { world_id: World.all.first.id, user_id: User.all.first.id, message: 'Anyone want to team up?', created_at: Time.now, updated_at: Time.now },
  { world_id: World.all.first.id, user_id: User.all.first.id, message: 'This world is private, keep it low-key!', created_at: Time.now, updated_at: Time.now },
  { world_id: World.all.first.id, user_id: User.all.first.id, message: 'Hello, anyone here?', created_at: Time.now, updated_at: Time.now }
]

messages.each do |msg|
  Message.create!(msg)
end

# Create all items
items = [{ item_name: 'XP Boost', description: 'Boosts your XP by 25 points', price: 5, is_interactable: true},
         { item_name: 'Speed Potion', description: 'Lets you move past adjacent cells for no cost', price: 1, is_interactable: true},
         { item_name: '4 Leaf Clover', description: 'Increases your minigame luck', price: 10, is_interactable: true}]


items.each do |item|
  Item.create!(item)
end

