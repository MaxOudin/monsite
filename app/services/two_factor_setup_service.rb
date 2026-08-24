# frozen_string_literal: true

class TwoFactorSetupService
  def initialize(user)
    @user = user
  end

  def call
    return false if @user.otp_required_for_login?

    @user.otp_secret = User.generate_otp_secret
    @user.otp_required_for_login = false
    @user.save!
  end
end
