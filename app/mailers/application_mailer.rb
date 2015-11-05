class ApplicationMailer < ActionMailer::Base
  default from: "no_reply@makechow.com"
  layout 'mailer'
end
