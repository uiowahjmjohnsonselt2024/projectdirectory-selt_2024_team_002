class UserMailer < ApplicationMailer
  def send_reset_password_email(email)
    @url = 'http://localhost:3000/users/reset-password' # Add any relevant link
    mail(
      to: email,
      subject: 'Reset your SELT password!',
      template_name: 'reset_password_email'
    )
  end
end
