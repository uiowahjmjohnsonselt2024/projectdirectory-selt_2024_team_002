class Quest < ApplicationRecord
    belongs_to :user_world
    belongs_to :world
  
    def self.generate_movement_for(user_world)
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

    def self.generate_trivia_for(user_world)
      world = user_world.world
      create!(
        user_world: user_world,
        world: world,
        completed: false,
        trivia_question: random_trivia_question
      )
    end

    def self.random_trivia_question
      questions = [
        { question: 'What is the capital of France?', choices: ['Paris', 'London', 'Berlin', 'Madrid'], answer: 'Paris' },
        { question: 'What is the capital of Germany?', choices: ['Berlin', 'Mumbai', 'Pyongyang', 'Seol'], answer: 'Berlin' },
        { question: "What is 2+2?", choices: ['3', '4', '5', '6'], answer: '4' },
        { question: "Who wrote 'Romeo and Juliet'?", choices: ['Shakespeare', 'Hemingway', 'Tolstoy', 'Dickens'], answer: 'Shakespeare' }
      ]

      questions.sample
    end

    def complete_trivia(answer)
      if answer == trivia_question[:answer]
        user_world.user.increment!(:available_credits, 5)
        user_world.increment!(:xp, 15)
        update!(completed: true)
      else
        false
      end
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