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

  # Un champ est obligatoire s'il porte une validation de présence
  # (aligné sur les contraintes NOT NULL en base — cf. documentation/09 branche 3).
  def required_field?(object, attribute)
    return false unless object.respond_to?(:class) && object.class.respond_to?(:validators_on)

    object.class.validators_on(attribute).any? do |validator|
      validator.is_a?(ActiveModel::Validations::PresenceValidator)
    end
  end

  # Astérisque rouge signalant un champ obligatoire dans les formulaires.
  def required_mark(object, attribute)
    return unless required_field?(object, attribute)

    tag.span(" *", class: "text-red-600", title: "Champ obligatoire", aria: { hidden: true })
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

  def otp_qr_svg(user, size: 200)
    return if user.otp_secret.blank?

    uri = user.otp_provisioning_uri(user.email, issuer: user.otp_provisioning_issuer)
    svg = RQRCode::QRCode.new(uri).as_svg(
      module_size: 4,
      standalone: true,
      use_path: true,
      viewbox: true,
      fill: "fff",
      color: "000"
    )
    # La déclaration XML casse le rendu quand le SVG est injecté dans du HTML.
    svg.sub(/\A<\?xml[^>]*\?>/, "").html_safe
  end
end
