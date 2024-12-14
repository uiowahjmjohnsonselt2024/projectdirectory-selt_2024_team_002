# frozen_string_literal: true

# The world that a user can join, including functions to initialize and
# update/retrieve information from a displayed grid.
# represents the model class for the worlds object
class World < ApplicationRecord
  has_many :gridsquares, dependent: :destroy

  has_many :user_worlds, dependent: :destroy
  has_many :users, through: :user_worlds

  validates :current_players, numericality: { greater_than_or_equal_to: 0 }
  before_create :init_current_players
  @@dim = 6 # rubocop:disable Style/ClassVars

  # this must be done this way, active stroage DOES NOT WORK
  # with after_create call back when seeding!!!!!!!
  def init_if_not_inited
    return unless gridsquares.empty?

    initialize_grid
  end

  def self.dim
    @@dim
  end

  def generate_quest_for(user)
    user_world = user.user_worlds.find_by(world: self)
    return unless user_world

    return if user_world.quests.where(completed: false).exists?

    if Kernel.rand < 0.5
      Quest.generate_movement_for(user_world)
      Rails.logger.debug 'movement quest'
    else
      Quest.generate_trivia_for(user_world)
      Rails.logger.debug 'trivia quest'
    end
  end

  private

  def initialize_grid
    (1..@@dim).each do |row|
      (1..@@dim).each do |col|
        gridsquares.create!(row: row, col: col)
        OpenaiEvent.new(row: row, col: col, world_id: id).save!
      end
    end
  end

  def init_current_players
    self.current_players ||= 0
  end
end
