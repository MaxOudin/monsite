class Article < ApplicationRecord
  THEMES_WITH_COLORS = {
    "Autour du web" => "#18435A",
    "Les étapes clés du site internet" => "#564787",
    "Les performances" => "#424B54",
    "Sécurité sur le web" => "#16324F",
    "Ecologie et développement web" => "#386641",
    "Les métiers du web" => "#2E282A"
  }

  has_rich_text :content

  validates :titre, presence: true, uniqueness: true
  validates :content, presence: true
  validates :image_url, presence: true
  validates :image_alt, presence: true
  validates :couleur, presence: true
  validates :theme, presence: true, inclusion: { in: THEMES_WITH_COLORS.keys }

  # Méthode pour récupérer la couleur associée à un thème
  def couleur_du_theme
    THEMES_WITH_COLORS[theme]
  end

end
