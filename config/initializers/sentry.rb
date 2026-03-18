# frozen_string_literal: true

Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']

  # Breadcrumbs
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Environnement
  config.environment = Rails.env.to_s
  config.enabled_environments = %w[production staging]

  # Performance monitoring – ajuste selon le trafic réel (ici 10%)
  config.traces_sample_rate = ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', '0.1').to_f

  # Ne pas envoyer de données personnelles (cookies, body, IP...)
  config.send_default_pii = false

  # Filtrer les erreurs peu actionnables
  config.excluded_exceptions += %w[
    ActionController::RoutingError
    ActionController::BadRequest
    ActiveRecord::RecordNotFound
    Rack::Attack::Error
  ]
end

Rails.logger.info "[Sentry] initialized: #{Sentry.initialized?} | env: #{Rails.env} | dsn configured: #{ENV['SENTRY_DSN'].present?}"
