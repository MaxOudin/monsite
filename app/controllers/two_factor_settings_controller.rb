# frozen_string_literal: true

class TwoFactorSettingsController < ApplicationController
  before_action :authenticate_user!

  def show
    current_user.reload
    @pending_setup = current_user.otp_secret.present? && !current_user.otp_required_for_login?
  end

  def create
    if TwoFactorSetupService.new(current_user).call
      redirect_to two_factor_settings_path,
                  status: :see_other,
                  notice: "Scannez le QR code puis confirmez avec un code de votre application."
    else
      redirect_to two_factor_settings_path,
                  status: :see_other,
                  alert: "La double authentification est déjà activée."
    end
  end

  def confirm
    result = TwoFactorConfirmService.new(current_user, otp_attempt: params[:otp_attempt]).call

    if result.success?
      session[:otp_backup_codes] = result.backup_codes
      redirect_to backup_codes_two_factor_settings_path,
                  notice: "Double authentification activée. Conservez vos codes de secours."
    else
      redirect_to two_factor_settings_path, alert: alert_for(result.error)
    end
  end

  def backup_codes
    @backup_codes = session.delete(:otp_backup_codes)
    redirect_to two_factor_settings_path, alert: "Aucun code de secours à afficher." if @backup_codes.blank?
  end

  def destroy
    result = TwoFactorDisableService.new(
      current_user,
      password: params[:password],
      otp_attempt: params[:otp_attempt]
    ).call

    if result.success?
      redirect_to two_factor_settings_path, notice: "Double authentification désactivée."
    else
      redirect_to two_factor_settings_path, alert: alert_for(result.error)
    end
  end

  private

  def alert_for(error)
    case error
    when :invalid_otp then "Code de vérification invalide."
    when :invalid_password then "Mot de passe incorrect."
    when :already_enabled then "La double authentification est déjà activée."
    when :missing_secret then "Démarrez d'abord la configuration."
    when :not_enabled then "La double authentification n'est pas activée."
    when :persist_failed then "Impossible d'enregistrer l'activation 2FA. Réessayez."
    else "Une erreur est survenue."
    end
  end
end
