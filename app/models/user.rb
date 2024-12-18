# frozen_string_literal: true

require 'bcrypt'

# Model dealing with user accounts
class User < ApplicationRecord
  has_many :friendships, dependent: :destroy, inverse_of: :user
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy,
                                 inverse_of: :user
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :user_worlds, dependent: :destroy
  has_many :worlds, through: :user_worlds

  validates :email, presence: { message: 'is required.' }, 'valid_email_2/email': true
  validates :display_name, presence: { message: 'is required.' }, uniqueness: { message: '%<value>s is taken' }
  has_secure_password
  validate :password_complexity

  def update_session_token
    self.session_token = SecureRandom.hex(32)
    save
  end

  def plus_user?
    plus_user
  end

  def purchase_plus_user
    cost_in_shards = 100 # Define the cost in shards for plus_user access
    if available_credits >= cost_in_shards
      self.available_credits -= cost_in_shards
      self.plus_user = true
      save
      true
    else
      false
    end
  end

  def generate_reset_password_token
    self.reset_password_token = SecureRandom.hex(32)
    self.reset_password_sent_at = Time.now.utc
    save
  end

  def invalid_reset_password_token?
    reset_password_sent_at.nil? || reset_password_token.nil? || reset_password_sent_at < 1.hour.ago
  end

  def update_password(new_password)
    self.password = new_password
    save
  end

  def charge_credits(num)
    return false unless available_credits >= num

    self.available_credits -= num
    save
  end

  private

  # rubocop:disable all 
  # rubo cop complains that it's too long. and too many conditionals. The alternative is to have all
  # these as oneliner functions which is also bad....
  def password_complexity #thanks chatGPT :) 
    return if password.blank?
    password_rules = {
      length: { condition: ->(pwd) { pwd.length >= 12 }, message: 'must be longer than 12 characters' },
      digit: { condition: ->(pwd) { pwd.match?(/\d/) }, message: 'must include a digit' },
      uppercase: { condition: ->(pwd) { pwd.match?(/[A-Z]/) }, message: 'must include one uppercase letter' },
      lowercase: { condition: ->(pwd) { pwd.match?(/[a-z]/) }, message: 'must include one lowercase letter' },
      special_char: { condition: ->(pwd) { pwd.match?(/[\W_]/) }, message: 'must include one special character' }
    }
    password_rules.each do |key, rule|
      unless rule[:condition].call(password)
        errors.add(:password, rule[:message])
        break
      end
    end
  end
  # https://api.rubyonrails.org/v7.1/classes/ActiveModel/SecurePassword/ClassMethods.html
  # use authenticate for checking the password

  def self.find_user_by_display_name(display_name)
    User.where(['display_name = ?', display_name]).first
  end

  def self.find_user_by_session_token(session_token)
    User.where(['session_token = ?', session_token]).first
  end
end
