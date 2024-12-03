# frozen_string_literal: true

# WIP class for forget password emails
class UserMailer < ApplicationMailer
  def send_reset_password_email(user)
    @reset_url = reset_password_url(token: user.reset_password_token)
    Rails.logger.debug "Generated Reset URL: #{@reset_url}"
    mail(
      to: user.email,
      from: 'adervesh03@gmail.com',
      subject: 'Reset your SELT password!',
      template_name: 'reset_password_email'
    )
  end
end
