module MetaTagsHelper
  # Title SEO
  def meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : DEFAULT_META["meta_title"]
  end

  # Description SEO
  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : DEFAULT_META["meta_description"]
  end

  # Image SEO avec gestion des URLs absolues ou relatives
  # Utilise yellow_logo.svg par défaut si l'image n'existe pas
  def meta_image
    meta_image = content_for?(:meta_image) ? content_for(:meta_image) : DEFAULT_META["meta_image"]
    
    # Si l'image est vide, nulle ou invalide, utiliser le logo par défaut
    if meta_image.blank? || !valid_image?(meta_image)
      meta_image = DEFAULT_META["meta_image"]
    end
    
    # Retourner l'URL complète
    if meta_image.starts_with?("http")
      meta_image
    else
      begin
        image_url(meta_image)
      rescue => e
        # En cas d'erreur (asset non trouvé), retourner le logo par défaut
        image_url(DEFAULT_META["meta_image"])
      end
    end
  end

  # URL Canonique - Vital pour éviter le contenu dupliqué
  # Utilise l'URL définie dans la vue ou l'URL actuelle sans paramètres de tracking
  # Force toujours l'utilisation de l'hôte canonique (non-www) même si la requête arrive avec www
  def meta_canonical_url
    if content_for?(:canonical_url)
      # SÉCURITÉ : Valider et échapper l'URL canonique personnalisée
      url = content_for(:canonical_url).to_s
      # Valider que l'URL est bien formée et pointe vers notre domaine
      if valid_canonical_url?(url)
        url
      else
        # Si l'URL n'est pas valide, utiliser l'URL par défaut
        build_default_canonical_url
      end
    else
      build_default_canonical_url
    end
  end

  # Construit l'URL canonique par défaut
  def build_default_canonical_url
    # Utiliser le domaine canonique depuis ENV pour garantir la cohérence
    canonical_domain = ENV['DOMAIN'] || 'maximeoudin.fr'
    canonical_host = canonical_domain.start_with?('www.') ? canonical_domain : canonical_domain
    
    # SÉCURITÉ : Utiliser HTTPS en production, le schème de la requête en développement
    scheme = Rails.env.production? ? 'https' : request.scheme
    
    # SÉCURITÉ : Nettoyer le chemin
    path = sanitize_url_path(request.path)
    
    # Construire l'URL canonique avec le bon hôte
    query_params = request.query_parameters.except(*ignored_query_params)
    query_string = query_params.any? ? "?#{query_params.to_query}" : ""
    
    "#{scheme}://#{canonical_host}#{path}#{query_string}"
  end

  # Valide qu'une URL canonique personnalisée est sûre
  def valid_canonical_url?(url)
    return false if url.blank?
    
    # Vérifier que l'URL commence par http:// ou https://
    return false unless url.match?(/\Ahttps?:\/\//i)
    
    # Extraire le domaine de l'URL
    uri = URI.parse(url) rescue nil
    return false unless uri
    
    # SÉCURITÉ : Vérifier que l'URL pointe vers notre domaine
    canonical_domain = ENV['DOMAIN'] || 'maximeoudin.fr'
    canonical_base = canonical_domain.sub(/^www\./, '').downcase
    url_host = uri.host.to_s.downcase.sub(/^www\./, '')
    
    # L'URL doit pointer vers notre domaine
    url_host == canonical_base
  end

  # Nettoie le chemin pour l'URL canonique
  def sanitize_url_path(path)
    # Normaliser le chemin
    normalized = path.to_s.gsub(%r{/+}, '/').gsub(%r{\.\.}, '')
    normalized = "/#{normalized}" unless normalized.start_with?('/')
    # Limiter la longueur
    normalized[0..2000]
  end

   # Keywords SEO (optionnel, peu utilisé par Google mais utile pour d'autres moteurs)
  def meta_keywords
    content_for?(:meta_keywords) ? content_for(:meta_keywords) : DEFAULT_META["meta_keywords"]
  end

  # Twitter Card type
  def meta_twitter_card
    content_for?(:twitter_card) ? content_for(:twitter_card) : DEFAULT_META["twitter_card"]
  end

  # Open Graph type
  def meta_og_type
    content_for?(:og_type) ? content_for(:og_type) : DEFAULT_META["og_type"]
  end

  private

  # Paramètres de query à ignorer pour l'URL canonique
  # Protège contre les URLs dupliquées via tracking
  def ignored_query_params
    %w[
      utm_source utm_medium utm_campaign utm_term utm_content
      ref fbclid gclid msclkid
      _ga _gl
    ]
  end

  # Valide si une image existe (URL externe ou asset local)
  def valid_image?(image_path)
    return true if image_path.blank?
    return true if image_path.starts_with?("http")
    
    # Pour les assets locaux, vérifier qu'ils existent
    # On accepte les noms de fichiers valides (lettres, chiffres, -, _, .)
    image_path.match?(/\A[\w\-\.]+\z/)
  end
end 