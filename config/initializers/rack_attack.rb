# config/initializers/rack_attack.rb
class Rack::Attack
  # 1. Configuration du Cache
  Rack::Attack.cache.store = Rails.cache
  # En développement/tests, éviter d'utiliser SolidCache (DB) pour Rack::Attack
  # afin d'éviter les erreurs de connexion (select_all on nil) et l'I/O DB inutile.
  if Rails.env.development? || Rails.env.test?
    Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
  end

  # === 2. LISTES BLANCHES (SAFELIST) ===

  safelist('allow health checks and assets') do |req|
    req.path.start_with?('/up', '/assets', '/packs')
  end

  # CRITICAL: Allow error pages to prevent infinite loops
  # When Rack::Attack blocks a request, Rails tries to render /403.html or /429.html
  # If these are also blocked, it causes an unhandled exception
  safelist('allow error pages') do |req|
    req.path.match?(/^\/(403|404|422|429|500|502|503)\.html$/)
  end

  # Avec Devise, warden.user retourne directement le modèle User (pas un wrapper avec .user)
  safelist('allow trusted users') do |req|
    req.env['warden']&.user.present?
  end

  # === 3. PROTECTION GÉNÉRALE (THROTTLE) ===
  
  throttle('req/ip', limit: 30, period: 1.minute) do |req|
    # Exclude static assets, health checks, AND error pages from throttling
    # Error pages MUST be excluded to prevent infinite loops when a blocked request tries to render /403.html
    unless req.path.start_with?('/assets', '/packs', '/up') ||
           req.path.match?(/^\/(403|404|422|429|500|502|503)\.html$/)
      req.ip
    end
  end

  throttle('req/authenticated', limit: 10, period: 1.minute) do |req|
    req.env['warden']&.user&.id if req.env['warden']&.user
  end

  # === 4. PROTECTION AUTHENTIFICATION (APPROCHE MANUELLE CORRIGÉE) ===

  # Throttle anti-rafale (web et API)
  throttle('logins/ip/post', limit: 5, period: 1.minute) do |req|
    if req.post? && (req.path == '/users/sign_in' || req.path == '/api/v1/login')
      req.ip
    end
  end

  # --- NIVEAU 1 (Modéré) ---
  # Bloque globalement (sans condition de path) si le compteur est trop élevé
  blocklist('logins/ip/fail_l1') do |req|
    # On lit le compteur. S'il dépasse 6, on bloque.
    count_key_l1 = "login_failures:#{req.ip}" # <- Clé corrigée
    Rack::Attack.cache_read_int(count_key_l1) >= 6 # <- Seuil corrigé
  end

  # --- NIVEAU 2 (Sévère) ---
  blocklist('logins/ip/fail_l2') do |req|
    # On lit le compteur. S'il dépasse 15, on bloque.
    count_key_l2 = "login_failures_severe:#{req.ip}" # <- Clé corrigée
    Rack::Attack.cache_read_int(count_key_l2) >= 15 # <- Seuil corrigé
  end
  
  # Écoute les notifications d'échec pour incrémenter les compteurs.
  ActiveSupport::Notifications.subscribe('rack.attack.login_failure') do |name, start, finish, id, payload|
    ip = payload[:request].ip
    
    # --- Compteur Niveau 1 ---
    # Incrémente la clé. Elle expirera 10 minutes après le *dernier* échec.
    count_key_l1 = "login_failures:#{ip}" # <- Clé corrigée
    Rack::Attack.cache_increment(count_key_l1, 1, expires_in: 10.minutes)
    
    # --- Compteur Niveau 2 ---
    # Idem, avec une fenêtre d'1 heure.
    count_key_l2 = "login_failures_severe:#{ip}" # <- Clé corrigée
    Rack::Attack.cache_increment(count_key_l2, 1, expires_in: 1.hour)
    
    Rails.logger.warn "[Rack::Attack] Login failure for #{ip}. Incrementing counters."
  end

  # Endpoint CSP : soumis au throttle général (30 req/min). Pas de safelist pour éviter le spam.

  # === 5. PROTECTION AUTRES ENDPOINTS SENSIBLES ===

  throttle('password_resets/ip', limit: 5, period: 1.hour) do |req|
    if req.path == '/users/password' && req.post?
      req.ip
    end
  end

  # Inscription désactivée (User sans :registerable) : cette règle ne matche pas en pratique.
  throttle('registrations/ip', limit: 10, period: 1.hour) do |req|
    if req.path == '/users' && req.post?
      req.ip
    end
  end

  # === 6. PROTECTION API ===
  
  throttle('api/ip', limit: 50, period: 1.minute) do |req|
    req.ip if req.path.start_with?('/api/')
  end

  # === 7. PROTECTION CONTRE LES SCANS DE SÉCURITÉ ===

  blocklist('block system file access') do |req|
    dangerous_paths = [
      /\.\./,
      /\.env/,
      /config\/database\.yml/,
      /config\/credentials/,
      /Gemfile\.lock/
    ]
    dangerous_paths.any? { |pattern| pattern.match?(req.path) }
  end

  # === 8. RÉPONSES PERSONNALISÉES ===
  
  # Responder pour les IPs bloquées (blocklist)
  # Creates a 403 Forbidden exception that will be caught by exceptions_app
  self.blocklisted_responder = lambda do |req|
    exception = StandardError.new("Access denied by Rack::Attack")
    error_response(req.env, exception, 403)
  end

  # Responder pour les rate limits (throttle)
  # Creates a 429 Too Many Requests exception that will be caught by exceptions_app
  self.throttled_responder = lambda do |req|
    exception = StandardError.new("Rate limited by Rack::Attack")
    error_response(req.env, exception, 429)
  end
  
  # Helper method to create a proper HTTP error *response* for Rack::Attack
  # IMPORTANT: we do NOT set env["action_dispatch.exception"] here,
  # otherwise Sentry/Rails would treat this as an unhandled exception.
  # We only pass a status code to ErrorsController via a dedicated env key.
  def self.error_response(env, exception, status)
    # Add the status code to the environment
    env['rack.attack.exception_status'] = status
    
    # Format the path as Rails expects for error pages
    # e.g., "/404.html" for a 404 error
    env['PATH_INFO'] = "/#{status}.html"
    
    # Call the exceptions app to handle this exception
    Rails.application.config.exceptions_app.call(env)
  end

  # === Helpers Cache Sûrs ===
  def self.cache_read_int(key)
    begin
      store = Rack::Attack.cache&.store
      return 0 unless store
      value = store.read(key)
      value.to_i
    rescue => e
      Rails.logger.debug("[Rack::Attack] cache_read_int failed for #{key}: #{e.message}") if defined?(Rails)
      0
    end
  end

  def self.cache_increment(key, amount, expires_in: nil)
    begin
      store = Rack::Attack.cache&.store
      return unless store && store.respond_to?(:increment)
      store.increment(key, amount, expires_in: expires_in)
    rescue => e
      Rails.logger.debug("[Rack::Attack] cache_increment failed for #{key}: #{e.message}") if defined?(Rails)
      nil
    end
  end

  # === 9. LOGGING ===
  
  ActiveSupport::Notifications.subscribe('rack.attack') do |name, start, finish, request_id, payload|
    req = payload[:request]
    
    case payload[:match_type]
    when :throttle
      user_info = req.env['warden']&.user ? " (User: #{req.env['warden'].user.id})" : ""
      Rails.logger.warn "[Rack::Attack][THROTTLE] #{req.ip} #{req.request_method} #{req.fullpath}#{user_info} - Rule: #{payload[:discriminator]}"
    when :blocklist
      user_info = req.env['warden']&.user ? " (User: #{req.env['warden'].user.id})" : ""
      Rails.logger.warn "[Rack::Attack][BLOCKED] #{req.ip} #{req.request_method} #{req.fullpath}#{user_info} - Rule: #{payload[:discriminator]}"
    when :safelist
      Rails.logger.info "[Rack::Attack][SAFELIST] #{req.ip} #{req.request_method} #{req.fullpath}"
    end
  end
end