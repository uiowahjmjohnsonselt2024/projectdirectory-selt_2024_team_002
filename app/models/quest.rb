class Quest < ApplicationRecord
    belongs_to :user_world
    belongs_to :world
  
    def self.generate_for(user_world)
      world = user_world.world
      filled_cells = world.gridsquares.select { |cell| cell.image.attached? }
      return if filled_cells.empty?
  
      target_cell = filled_cells.sample
      create!(
        user_world: user_world,
        world: world,
        cell_row: target_cell.row,
        cell_col: target_cell.col,
        completed: false
      )
    end

    def random_quest_message(description)
      quest_messages = [
        "Find the sword in the #{description}",
        "Find the treasure in the #{description}",
        "Find the key in the #{description}",
        "Find the potion in the #{description}",
        "I'm looking for my cat in the #{description}",
        "I'm looking for my dog in the #{description}"
      ]

      quest_messages.sample
    end
  
    def complete
      user_world.user.increment!(:available_credits, 5)
      user_world.increment!(:xp, 15)
      update!(completed: true)
    end
  end