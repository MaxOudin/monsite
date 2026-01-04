# Middleware pour rediriger www vers non-www (ou vice versa)
# Assure qu'un seul hôte est canonique pour le SEO
class CanonicalHostRedirect
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    
    # Récupérer le domaine canonique depuis ENV
    canonical_domain = ENV['DOMAIN'] || 'maximeoudin.fr'
    canonical_has_www = canonical_domain.start_with?('www.')
    canonical_host = canonical_has_www ? canonical_domain : canonical_domain
    canonical_base = canonical_domain.sub(/^www\./, '').downcase
    
    # Récupérer et normaliser l'hôte de la requête
    host = request.host.to_s.downcase
    host_has_www = host.start_with?('www.')
    host_base = host.sub(/^www\./, '')
    
    # SÉCURITÉ : Valider que l'hôte correspond bien au domaine canonique
    # pour éviter les redirections vers des domaines externes
    return @app.call(env) unless host_base == canonical_base
    
    # Vérifier si l'hôte de la requête correspond au domaine canonique
    # mais avec un préfixe www différent
    if host_has_www != canonical_has_www
      # SÉCURITÉ : Valider et nettoyer le chemin pour éviter path traversal
      path = sanitize_path(request.path)
      query_string = request.query_string.present? ? "?#{sanitize_query_string(request.query_string)}" : ""
      
      # SÉCURITÉ : Utiliser uniquement le schème de la requête si HTTPS, sinon forcer HTTPS en production
      scheme = Rails.env.production? ? 'https' : request.scheme
      
      # Redirection 301 vers la version canonique
      redirect_url = "#{scheme}://#{canonical_host}#{path}#{query_string}"
      return [301, { 'Location' => redirect_url, 'Content-Type' => 'text/html' }, []]
    end
    
    # Pas de redirection nécessaire, continuer normalement
    @app.call(env)
  end

  private

  # Nettoie le chemin pour éviter path traversal et autres attaques
  def sanitize_path(path)
    # Normaliser le chemin (supprimer les .., //, etc.)
    normalized = path.gsub(%r{/+}, '/').gsub(%r{\.\.}, '')
    # S'assurer que le chemin commence par /
    normalized = "/#{normalized}" unless normalized.start_with?('/')
    # Limiter la longueur pour éviter les attaques par buffer overflow
    normalized[0..2000]
  end

  # Nettoie la query string pour éviter l'injection
  def sanitize_query_string(query_string)
    # Rails échappe automatiquement les paramètres, mais on limite la longueur
    query_string[0..2000]
  end
end

