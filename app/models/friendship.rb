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

  # given an user instance, fetch all userids of the users friends.
  def self.friend_ids(usr)
    # if max is friends with admin
    # There should be a friendship with (maxID, adminID) OR (adminID, maxID)
    # But not both. So it’s a query to get both cases
    Friendship.where(friend_id: usr.id, status: 'accepted')
              .pluck(:user_id)
              .concat(Friendship.where(user_id: usr.id, status: 'accepted')
                                           .pluck(:friend_id))
              .uniq
  end

  # given an user instance, fetch all friend requests from the DB
  def self.requested_friend_ids(usr)
    Friendship.where(friend_id: usr.id, status: 'pending')
              .pluck(:user_id)
              .uniq
  end

  private

  def not_self
    errors.add(:friend_id, 'Unfortunately, you cannot add yourself as a friend.') if user_id == friend_id
  end
end
