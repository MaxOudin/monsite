# frozen_string_literal: true

class TwoFactorConfirmService
  Result = Struct.new(:success?, :backup_codes, :error, keyword_init: true)

  def initialize(user, otp_attempt:)
    @user = user
    @otp_attempt = otp_attempt
  end

  def call
    return Result.new(success?: false, error: :already_enabled) if @user.otp_required_for_login?
    return Result.new(success?: false, error: :missing_secret) if @user.otp_secret.blank?
    return Result.new(success?: false, error: :invalid_otp) unless @user.validate_and_consume_otp!(@otp_attempt)

    backup_codes = nil
    @user.transaction do
      @user.otp_required_for_login = true
      backup_codes = @user.generate_otp_backup_codes!
      @user.save!
    end

    Result.new(success?: true, backup_codes: backup_codes)
  end
end
