# frozen_string_literal: true

class TwoFactorSetupService
  def initialize(user)
    @user = user
  end

  def call
    return false if @user.otp_required_for_login?

    @user.otp_secret = User.generate_otp_secret
    @user.otp_backup_codes = nil
    @user.consumed_timestep = nil
    @user.otp_required_for_login = false
    @user.save!
    @user.reload
    raise "otp_secret non persisté" if @user.otp_secret.blank?

    true
  end
end
