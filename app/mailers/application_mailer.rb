class ApplicationMailer < ActionMailer::Base
  default from: ENV["SMTP_FROM"] || "contact@maximeoudin.fr"
  layout "mailer"
end
