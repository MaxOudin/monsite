# frozen_string_literal: true

class TwoFactorDisableService
  Result = Struct.new(:success?, :error, keyword_init: true)

  def initialize(user, password:, otp_attempt:)
    @user = user
    @password = password
    @otp_attempt = otp_attempt
  end

  def call
    return Result.new(success?: false, error: :not_enabled) unless @user.otp_required_for_login?
    return Result.new(success?: false, error: :invalid_password) unless @user.valid_password?(@password)
    return Result.new(success?: false, error: :invalid_otp) unless valid_second_factor?

    @user.transaction do
      @user.otp_required_for_login = false
      @user.otp_secret = nil
      @user.otp_backup_codes = nil
      @user.consumed_timestep = nil
      @user.save!
    end

    Result.new(success?: true)
  end

  private

  def valid_second_factor?
    return true if @user.validate_and_consume_otp!(@otp_attempt)

    if @user.invalidate_otp_backup_code!(@otp_attempt)
      @user.save!
      true
    else
      false
    end
  end
end
