class Friendship < ApplicationRecord
  validates :user_name, uniqueness: { scope: :friend_name }
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :friend_name, presence: true
  validates :user_name, uniqueness: { scope: :friend_name }

  validate :not_self

  private

  def not_self
    errors.add(:friend_name, "Unfortunately, you cannot add yourself as a friend.") if user_name == friend_name
  end
end
