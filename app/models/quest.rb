# frozen_string_literal: true

# Model for handling quest-related actions.
class Quest < ApplicationRecord
  class NoFilledCellsError < StandardError; end
  belongs_to :user_world
  belongs_to :world

  # rubocop:disable Metrics/MethodLength
  def self.generate_movement_for(user_world)
    world = user_world.world
    filled_cells = world.gridsquares.select { |cell| cell.image.attached? }

    raise NoFilledCellsError, 'No filled cells to generate quest' if filled_cells.empty?

    target_cell = filled_cells.sample
    create!(
      user_world: user_world,
      world: world,
      cell_row: target_cell.row,
      cell_col: target_cell.col,
      completed: false
    )
  end
  # rubocop:enable Metrics/MethodLength

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
      { question: 'What is the capital of France?', choices: %w[Paris London Berlin Madrid], answer: 'Paris' },
      { question: 'What is the capital of Germany?', choices: %w[Berlin Mumbai Pyongyang Seol], answer: 'Berlin' },
      { question: 'What is 2+2?', choices: %w[3 4 5 6], answer: '4' },
      { question: "Who wrote 'Romeo and Juliet'?", choices: %w[Shakespeare Hemingway Tolstoy Dickens],
        answer: 'Shakespeare' }
    ]

    questions.sample
  end

  def complete_trivia(answer)
    if answer == trivia_question['answer']
      user_world.user.increment(:available_credits, 5).save!
      user_world.gain_xp(15)
      update!(completed: true)
      true
    else
      update!(completed: true)
      false
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.random_quest_message(quest)
    world = quest.world
    gridsquare = world.gridsquares.find_by(row: quest.cell_row, col: quest.cell_col)
    description = gridsquare.description

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
  # rubocop:enable Metrics/MethodLength

  def self.check_and_complete_movement_quest(user_world, row, col, flash)
    quest = user_world.quests.find_by(completed: false)
    return unless quest

    Rails.logger.debug 'checking movement quest'

    if quest.cell_row == row && quest.cell_col == col
      quest.complete_movement(flash)
      true
    else
      false
    end
  end

  def complete_movement(flash)
    user_world.user.increment(:available_credits, 5).save!
    user_world.gain_xp(15)
    update!(completed: true)
    flash[:alert] = 'Quest completed.'
  end

  def move_quest?
    trivia_question.nil?
  end
end
