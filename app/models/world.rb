# frozen_string_literal: true

require 'concurrent'

# The world that a user can join, including functions to initialize and
# update/retrieve information from a displayed grid.
require 'net/http'
require 'json'

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

    Quest.generate_for(user_world)
  end

  private

  def initialize_grid
    (1..@@dim).each do |row|
      (1..@@dim).each do |col|
        gridsquares.create!(row: row, col: col)
      end
    end
    # only these squares or we get rate limited.
    Concurrent::Future.execute { OpenaiWrapperHelper.create_square(1, 1, self) }
    Concurrent::Future.execute { OpenaiWrapperHelper.create_square(2, 1, self) }
    Concurrent::Future.execute { OpenaiWrapperHelper.create_square(2, 2, self) }
    Concurrent::Future.execute { OpenaiWrapperHelper.create_square(1, 2, self) }
  end

  def init_current_players
    self.current_players ||= 0
  end
end
