# frozen_string_literal: true

# UserWorld class is a model class that represents the relationship between a user and a world.
class UserWorld < ApplicationRecord
  belongs_to :user
  belongs_to :world

  validates :xp, numericality: { greater_than_or_equal_to: 0 }

  def validate_seen_and_position
    seen.each do |pair|
      errors.add(attr, 'len of seen pair must be 2') if pair.length > 2
      errors.add(attr, 'len of seen pair must be 2') unless (1..World.dim).include?(pair[0])
      errors.add(attr, 'len of seen pair must be 2') unless (1..World.dim).include?(pair[1])
    end
    errors.add(attr, 'user col position must be in range') unless (1..World.dim).include?(user_col)
    errors.add(attr, 'user col position must be in range') unless (1..World.dim).include?(user_row)
  end
end
