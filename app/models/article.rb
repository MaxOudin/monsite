# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  titre      :string
#  image_url  :string
#  image_alt  :string
#  couleur    :string
#  theme      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#
# Indexes
#
#  index_articles_on_slug  (slug) UNIQUE
#

class Article < ApplicationRecord
  extend FriendlyId
  friendly_id :titre, use: [:slugged, :history]

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

  # Méthode de classe pour compter les articles par thème
  def self.count_by_theme
    group(:theme).count
  end

  # Méthode de recherche sécurisée
  def self.search(query)
    return all unless query.present?

    query = query.to_s.strip

    # Utiliser la même structure de jointure pour les deux requêtes
    base_query = joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_id = articles.id AND action_text_rich_texts.record_type = 'Article' AND action_text_rich_texts.name = 'content'")

    # Recherche dans les attributs de base et le contenu
    base_query.where("articles.titre ILIKE :query OR articles.theme ILIKE :query OR action_text_rich_texts.body ILIKE :query", query: "%#{query}%").distinct
  end
end
