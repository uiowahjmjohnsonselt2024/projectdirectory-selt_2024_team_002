# frozen_string_literal: true

# class for messsages in worlds
class Message < ApplicationRecord
  belongs_to :world
  belongs_to :user

  validates :message, presence: true

  def self.get_messages_for_world(world_id)
    Message.where(world: world_id).order(created_at: :desc).limit(20)
  end
end
