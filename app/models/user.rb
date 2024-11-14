require 'bcrypt'

class User < ActiveRecord::Base
  class NonUniqueDisplayNameError < ArgumentError
  end

  validates :email, presence: true
  validates :password_hash, presence: true
  validates :session_token, presence: true
  validates :display_name, presence: true
  validates :created_at, presence: true
  validates :updated_at, presence: true

  # creates a new user and enforces unique display name
  # returns User object if successful, nil otherwise
  def self.create_user(email, password, display_name)
    if User.find_user_by_display_name(display_name) != nil
      raise NonUniqueDisplayNameError "Username already exists"
    else
      hashed_password = BCrypt::Password.create(password)

      user = User.new
      user[:email] = email
      user[:password_hash] = hashed_password
      user[:display_name] = display_name
      user[:available_credits] = 0
      user[:session_token] = SecureRandom.hex
      user[:created_at] = Time.now
      user[:updated_at] = Time.now
      user.save ? user : nil
    end
  end

  # verifies if login info is valid
  # returns true if successful, false otherwise
  def self.verify_user(display_name, password)
    user = find_user_by_display_name(display_name)
    if user != nil and BCrypt::Password.new(user.password_digest) == password
      true
    else
      false
    end
  end

  # updates the user's session token
  # returns true if successful, false otherwise
  def update_session_token
    self.session_token = SecureRandom.hex
    self.save
  end

  # finds user by display name and password
  # returns User object if found, nil otherwise
  def self.find_user_by_display_name_and_password(display_name, password)
    User.where("display_name = ? AND password_digest = ?", display_name, password).first
  end

  # finds user by email and password
  # returns User object if found, nil otherwise
  def self.find_user_by_email_and_password(email, password)
    User.where("email = ? AND password_digest = ?", email, password).first
  end

  # finds user by email
  # returns User object if found, nil otherwise
  def self.find_user_by_email(email)
    User.where("email = ?", email).first
  end

  # finds user by username
  # returns User object if found, nil otherwise
  def self.find_user_by_display_name(display_name)
    User.where("display_name = ?", display_name).first
  end

  # finds user by password
  # returns User object if found, nil otherwise
  def self.find_user_by_password(password)
    User.where("password_digest = ?", password).first
  end


  # finds user by session token
  # returns User object if found, nil otherwise
  def self.find_user_by_session_token(session_token)
    User.where("session_token = ?", session_token).first
  end

end
