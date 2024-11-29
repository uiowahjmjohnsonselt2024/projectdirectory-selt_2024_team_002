# frozen_string_literal: true

# default ActionMailer from rails
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
