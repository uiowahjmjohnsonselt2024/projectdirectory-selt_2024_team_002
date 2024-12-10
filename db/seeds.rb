# frozen_string_literal: true

worlds = [{ world_code: '12321', world_name: 'Test World 1', user_id_id: '1', is_public: true,
            max_player: '5', current_players: 0 },
          { world_code: '12322', world_name: 'Test World 2', user_id_id: '1', is_public: false,
            max_player: '5', current_players: 0 }]

worlds.each do |world|
  World.create!(world)
end

users = [{ email: 'admin@admin.com', password: 'AdminsAreTheBest1$', display_name: 'admin', available_credits: 100000,
           plus_user: true }]

users.each do |user|
  User.create!(user)
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