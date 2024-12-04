# frozen_string_literal: true

# UserWorld class is a model class that represents the relationship between a user and a world.
class UserWorld < ApplicationRecord
  belongs_to :user
  belongs_to :world

  validates :xp, numericality: { greater_than_or_equal_to: 0 }
end
