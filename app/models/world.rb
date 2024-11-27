# frozen_string_literal: true

# The world that a user can join, including functions to initialize and
# update/retrieve information from a displayed grid.
require 'net/http'
require 'json'

# represents the model class for the worlds object
class World < ApplicationRecord
  has_many :gridsquares, dependent: :destroy
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

  private

  def initialize_grid
    (1..@@dim).each do |row|
      (1..@@dim).each do |col|
        gridsquares.create!(row: row, col: col)
      end
    end
    OpenaiWrapperHelper.create_square(1, 1, self) # only these squares or we get rate limited.
    OpenaiWrapperHelper.create_square(2, 1, self)
    OpenaiWrapperHelper.create_square(2, 2, self)
    OpenaiWrapperHelper.create_square(1, 2, self)
  end
end
