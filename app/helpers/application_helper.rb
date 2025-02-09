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
end
