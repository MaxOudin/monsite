# frozen_string_literal: true

# Empêche rememberable de court-circuiter le 2FA sur un POST login
# (password présent). devise-two-factor laisse la cascade Warden ouverte
# pour les backup codes ; un cookie "remember me" ne doit pas authentifier
# à la place d'un OTP invalide.
module DeviseRememberableSkipOnPasswordLogin
  def valid?
    auth = params[:user] || params["user"]
    return false if auth && (auth[:password].present? || auth["password"].present?)

    super
  end
end

Rails.application.config.after_initialize do
  Devise::Strategies::Rememberable.prepend(DeviseRememberableSkipOnPasswordLogin)
end
