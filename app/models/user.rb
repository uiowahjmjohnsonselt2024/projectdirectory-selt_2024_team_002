require 'bcrypt'

class User < ActiveRecord::Base
  validates :email, presence: { message: "is required." }, 'valid_email_2/email': true
  validates :display_name, presence: { message: "is required." }, uniqueness: { message: " %{value} is taken" }
  has_secure_password 
  validate :password_complexity
  def update_session_token
    self.session_token = SecureRandom.hex(32)
    self.save
  end

  private
  # one error a time to not show 20 errors at a ti
  def password_complexity
    unless password_digest
      return #handled by has secure password but causes rspec to fail
    end
    unless password_digest.length >= 12
      errors.add(:password, "must be longer than 12 characters")
      return
    end
    unless password_digest.match?(/\d/)
      errors.add(:password, "must include a digit")
      return
    end
    unless password_digest.match?(/[A-Z]/)
      errors.add(:password, "must include one uppercase letter")
      return
    end
    unless password_digest.match?(/[a-z]/)
      errors.add(:password, "must include one lowercase letter")
      return
    end
    unless password_digest.match?(/[\W_]/)
      errors.add(:password, "must include one special character")
      return
    end
  end

  # https://api.rubyonrails.org/v7.1/classes/ActiveModel/SecurePassword/ClassMethods.html
  # use authenticate for checking the password
  

  def self.find_user_by_display_name(display_name)
    User.where(["display_name = ?", display_name]).first
  end


  def self.find_user_by_session_token(session_token)
    usr = User.where(["session_token = ?", session_token]).first
    usr
  end

end
