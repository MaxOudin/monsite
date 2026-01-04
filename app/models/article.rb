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
  include PgSearch::Model
  extend FriendlyId
  friendly_id :titre, use: [:slugged, :history]

  THEMES_WITH_COLORS = {
    "Autour du web" => "#18435A",
    "Les étapes clés du site internet" => "#564787",
    "Les performances" => "#424B54",
    "Sécurité sur le web" => "#16324F",
    "Ecologie et développement web" => "#386641",
    "Guide : créer son bot IA" => "#2E282A"
  }

  has_rich_text :content

  validates :titre, presence: true, uniqueness: true
  validates :content, presence: true
  validates :image_url, presence: true
  validates :image_alt, presence: true
  validates :couleur, presence: true
  validates :theme, presence: true, inclusion: { in: THEMES_WITH_COLORS.keys }

  pg_search_scope :search_articles,
    against: [:titre, :theme],
    associated_against: {
      rich_text_content: [:body]
    },
    using: {
      tsearch: {
        prefix: true
      }
    }

  # Méthode pour récupérer la couleur associée à un thème
  def couleur_du_theme
    THEMES_WITH_COLORS[theme]
  end

  # Méthode de classe pour compter les articles par thème
  def self.count_by_theme
    group(:theme).count
  end

end
