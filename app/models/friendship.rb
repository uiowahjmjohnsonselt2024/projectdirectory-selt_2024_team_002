# frozen_string_literal: true

# This defines a self-referential relationship between two users
class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :friend_id, presence: true
  validates :user_id, presence: true

  enum status: { pending: 'pending', accepted: 'accepted' }
  validates :status, presence: true

  validate :not_self

  private

  def not_self
    errors.add(:friend_id, 'Unfortunately, you cannot add yourself as a friend.') if user_id == friend_id
  end
end
