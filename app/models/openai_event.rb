# frozen_string_literal: true

# Model dealing with user accounts
class OpenaiEvent < ApplicationRecord
  validates :row, presence: { message: 'is required.' }, numericality: true
  validates :col, presence: { message: 'is required.' }, numericality: true
  validates :world_id, presence: { message: 'is required.' }, numericality: true
  validate :within_bounds

  def within_bounds
    dim = World.dim
    errors.add(:row, "must be a number between 1 and #{dim}.") unless row.is_a?(Integer) && row.between?(1, dim)
    return if col.is_a?(Integer) && col.between?(1, dim)

    errors.add(:col, "must be a number between 1 and #{dim}.")
  end
end
