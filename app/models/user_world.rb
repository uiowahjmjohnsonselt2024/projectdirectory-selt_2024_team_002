# frozen_string_literal: true

# UserWorld class is a model class that represents the relationship between a user and a world.
class UserWorld < ApplicationRecord
  belongs_to :user
  belongs_to :world

  validates :xp, numericality: { greater_than_or_equal_to: 0 }

  def self.free_move?(player_row, player_col, dest_row, dest_col)
    row_diff = (player_row - dest_row).abs
    col_diff = (player_col - dest_col).abs
    (row_diff == 1 && col_diff.zero?) || (row_diff.zero? && col_diff == 1)
  end

  def validate_seen_and_position
    seen.each do |pair|
      errors.add(attr, 'len of seen pair must be 2') if pair.length > 2
      errors.add(attr, 'len of seen pair must be 2') unless (1..World.dim).include?(pair[0])
      errors.add(attr, 'len of seen pair must be 2') unless (1..World.dim).include?(pair[1])
    end
    errors.add(attr, 'user col position must be in range') unless (1..World.dim).include?(user_col)
    errors.add(attr, 'user col position must be in range') unless (1..World.dim).include?(user_row)
  end

  def self.find_known_squares(user_id, world_id)
    UserWorld.where(user_id: user_id, world_id: world_id)
  end

  def set_position(row, col)
    self.user_row = row
    self.user_col = col
    save!
  end

  def self.find_by_ids(user_id, world_id)
    UserWorld.where(user_id: user_id, world_id: world_id).first
  end
end
