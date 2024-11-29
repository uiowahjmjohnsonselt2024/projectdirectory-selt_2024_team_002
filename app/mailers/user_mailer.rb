# frozen_string_literal: true

# WIP class for forget password emails
class UserMailer < ApplicationMailer
  def send_reset_password_email(email)
    @url = 'http://localhost:3000/users/reset-password'
    mail(
      to: email,
      from: 'adervesh03@gmail.com',
      subject: 'Reset your SELT password!',
      template_name: 'reset_password_email'
    )
  end
end
