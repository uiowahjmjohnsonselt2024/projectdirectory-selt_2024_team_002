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
  
    def complete
      user_world.user.increment!(:available_credits, 5)
      user_world.increment!(:xp, 15)
      update!(completed: true)
    end
  end