# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  titre      :string           not null
#  image_url  :string           not null
#  image_alt  :string           not null
#  couleur    :string           not null
#  theme      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#
# Indexes
#
#  index_articles_on_slug   (slug) UNIQUE
#  index_articles_on_titre  (titre) UNIQUE
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

  WORDS_PER_MINUTE = 200
  RELATED_LIMIT = 2

  has_rich_text :content

  validates :titre, presence: true, uniqueness: true
  validates :content, presence: true
  validates :image_url, presence: true
  validates :image_alt, presence: true
  validates :couleur, presence: true
  validates :theme, presence: true, inclusion: { in: THEMES_WITH_COLORS.keys }

  pg_search_scope :search_articles,
    against: [:titre],
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

  def reading_time_in_minutes
    words = content&.to_plain_text.to_s.split.size
    minutes = (words / WORDS_PER_MINUTE.to_f).ceil
    [minutes, 1].max
  end

  def related_articles(limit: RELATED_LIMIT)
    same_theme = self.class.where(theme: theme).where.not(id: id).order(created_at: :desc, id: :desc).limit(limit).to_a
    missing = limit - same_theme.size
    return same_theme if missing <= 0

    excluded_ids = same_theme.map(&:id) + [id]
    same_theme + self.class.where.not(id: excluded_ids).order(created_at: :desc, id: :desc).limit(missing).to_a
  end

end
