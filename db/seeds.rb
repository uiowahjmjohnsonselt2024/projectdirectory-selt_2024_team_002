

messages = [
  { world_id: World.first.id, user_id: User.first.id, message: 'Welcome to Test World 1!', created_at: Time.now, updated_at: Time.now },
  { world_id: World.first.id, user_id: User.first.id, message: 'Anyone want to team up?', created_at: Time.now, updated_at: Time.now },
  { world_id: World.second.id, user_id: User.first.id, message: 'This world is private, keep it low-key!', created_at: Time.now, updated_at: Time.now },
  { world_id: World.second.id, user_id: User.first.id, message: 'Hello, anyone here?', created_at: Time.now, updated_at: Time.now }
]

messages.each do |msg|
  Message.create!(msg)
end