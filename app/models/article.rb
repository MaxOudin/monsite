class Article < ApplicationRecord
  THEMES = [
    "Autour du web",
    "Les étapes clés du site internet",
    "Les performances",
    "Sécurité sur le web",
    "Ecologie et développement web",
    "Les métiers du web"
  ]

  has_rich_text :content

  validates :titre, presence: true, uniqueness: true
  validates :content, presence: true
  validates :image_url, presence: true
  validates :image_alt, presence: true
  validates :couleur, presence: true
  validates :theme, presence: true, inclusion: { in: THEMES }

end
