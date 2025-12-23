module ApplicationHelper
  def rgba_with_opacity(hex_color, opacity)
    # Supprimer le # si présent
    hex_color = hex_color.gsub('#', '')

    # Convertir les valeurs hex en RGB
    r = hex_color[0..1].to_i(16)
    g = hex_color[2..3].to_i(16)
    b = hex_color[4..5].to_i(16)

    # Retourner la couleur au format rgba
    "rgba(#{r}, #{g}, #{b}, #{opacity})"
  end

  # Valide si une URL ou un asset est valide pour l'affichage
  def valid_url_or_asset?(path)
    return false if path.blank?
    
    # Si c'est une URL HTTP/HTTPS, considérer comme valide
    return true if path.starts_with?("http://", "https://")
    
    # Sinon, vérifier que c'est un nom de fichier valide (pas de caractères bizarres)
    # Accepter lettres, chiffres, tirets, underscores, points et slashes
    path.match?(/\A[\w\-\.\/]+\z/)
  end
end
