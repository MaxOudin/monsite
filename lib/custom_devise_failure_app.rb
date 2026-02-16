# Notifie Rack::Attack des échecs de connexion web (POST /users/sign_in)
# pour que les blocklists logins/ip/fail_l1 et logins/ip/fail_l2 puissent s'activer.
class CustomDeviseFailureApp < Devise::FailureApp
  def respond
    notify_login_failure_if_sign_in_attempt
    super
  end

  private

  def notify_login_failure_if_sign_in_attempt
    return unless request.post? && request.path == "/users/sign_in"

    ActiveSupport::Notifications.publish(
      "rack.attack.login_failure",
      Time.current,
      Time.current,
      SecureRandom.uuid,
      { request: request }
    )
  end
end
