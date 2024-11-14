require 'bcrypt'

class User < ActiveRecord::Base
  validates :email, presence: { message: "Email is required." }
  validates :password_digest, presence: { message: "Password is required." }
  validates :display_name, presence: true, uniqueness: { message: "Username %{value} is taken" }
  has_secure_password # adds password_confirmation field 

  # verifies if login info is valid
  
  # updates the user's session token
  # throws an exception if the save is unsuccessful
  def update_session_token
    self.session_token = SecureRandom.hex(16)
    self.save
  end

  # https://api.rubyonrails.org/v7.1/classes/ActiveModel/SecurePassword/ClassMethods.html
  # use authenticate for checking the password
  
  # finds user by username
  # returns User object if found, nil otherwise
  def self.find_user_by_display_name(display_name)
    User.where(["display_name = ?", display_name]).first
  end

  # finds user by session token
  # returns User object if found, nil otherwise
  def self.find_user_by_session_token(session_token)
    usr = User.where("session_token = ?", session_token).first
    usr
  end

end
