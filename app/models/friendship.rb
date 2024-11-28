class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :friend_id, presence: true
  validates :user_id, uniqueness: { scope: :friend_id, message: 'Friendship already exists' }

  validate :not_self

  private

  def not_self
    errors.add(:friend_id, "Unfortunately, you cannot add yourself as a friend.") if user_id == friend_id
  end
end
