# frozen_string_literal: true

# UserWorld class is a model class that represents the relationship between a user and a world.
# Represents a unique user playing in a specific world
class UserWorld < ApplicationRecord
  belongs_to :user
  belongs_to :world
  has_many :inventory_items, dependent: :destroy
  has_many :items, through: :inventory_items
  has_many :quests, dependent: :destroy

  validates :xp, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_seen_and_position

  def self.free_move?(player_row, player_col, dest_row, dest_col)
    row_diff = (player_row.to_i - dest_row.to_i).abs
    col_diff = (player_col.to_i - dest_col.to_i).abs
    (row_diff == 1 && col_diff.zero?) || (row_diff.zero? && col_diff == 1)
  end

  def validate_seen_and_position
    seen.each do |pair|
      errors.add(:seen, 'len of seen pair must be 2') if pair.length > 2
      errors.add(:seen, 'row position must be in bounds') unless (1..World.dim).include?(pair[0].to_i)
      errors.add(:seen, 'col position must be in bounds') unless (1..World.dim).include?(pair[1].to_i)
    end
    errors.add(:seen, 'user col position must be in range') unless (1..World.dim).include?(user_col)
    errors.add(:seen, 'user col position must be in range') unless (1..World.dim).include?(user_row)
  end

  def self.find_known_squares(user_id, world_id)
    UserWorld.where(user_id: user_id, world_id: world_id).first.seen
  end

  # rubocop:disable Metrics/MethodLength
  def set_position(row, col)
    self.user_row = row
    self.user_col = col
    # update row col
    tiles = [[row.to_int - 1, col], [row.to_int + 1, col], [row, col.to_int + 1],
             [row, col.to_int - 1], [row, col]].filter do |el|
      (1..World.dim).include?(el[0]) && (1..World.dim).include?(el[1])
    end

    tiles.each do |tile|
      seen << tile unless seen.include?(tile)
    end
    Rails.logger.info('about to save')
    save!
  end
  # rubocop:enable Metrics/MethodLength

  def self.find_by_ids(user_id, world_id)
    UserWorld.where(user_id: user_id, world_id: world_id).first
  end

  def boost_xp
    self.xp_boost = 1.25
    self.xp_boost_count = 0
    save
  end

  # rubocop:disable Metrics/MethodLength
  def gain_xp(base_xp)
    boosted_xp = base_xp * xp_boost
    boosted_xp = boosted_xp.round

    self.xp += boosted_xp

    if self.xp > 100
      self.xp = self.xp - 100
      self.level += 1
    end

    if xp_boost > 1
      self.xp_boost_count += 1

      if xp_boost_count >= 5
        self.xp_boost = 1
        self.xp_boost_count = 0
      end
    end
    save
  end
  # rubocop:enable Metrics/MethodLength

  def speed_boost?
    speed_boost
  end

  def use_speed_potion
    self.speed_boost = true
    self.speed_boost_count = 0
    save
  end

  def update_speed_count
    self.speed_boost_count += 1
    if speed_boost_count >= 5
      self.speed_boost = false
      self.speed_boost_count = 0
    end
    save
  end

  def lucky?
    luck_boost
  end

  def use_leaf_clover
    self.luck_boost = true
    self.luck_boost_count = 0
    save
  end

  def update_luck_count
    self.luck_boost_count += 1
    if luck_boost_count >= 5
      self.luck_boost = false
      self.luck_boost_count = 0
    end
    save
  end
end
