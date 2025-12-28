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
  def meta_canonical_url
    if content_for?(:canonical_url)
      content_for(:canonical_url)
    else
      # URL actuelle sans paramètres de query de tracking
      url_for(only_path: false, params: request.query_parameters.except(*ignored_query_params))
    end
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