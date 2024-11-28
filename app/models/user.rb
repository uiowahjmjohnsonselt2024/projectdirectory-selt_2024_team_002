# frozen_string_literal: true

require 'bcrypt'

# Model dealing with user accounts
class User < ApplicationRecord
  has_many :friendships, dependent: :destroy, inverse_of: :user
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id', dependent: :destroy,
                                 inverse_of: :user
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  validates :email, presence: { message: 'is required.' }, 'valid_email_2/email': true
  validates :display_name, presence: { message: 'is required.' }, uniqueness: { message: '%<value>s is taken' }
  has_secure_password
  validate :password_complexity

  def update_session_token
    self.session_token = SecureRandom.hex(32)
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
      unless (rule[:condition].call(password))
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
