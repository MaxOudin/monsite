# == Schema Information
#
# Table name: projets
#
#  id            :integer          not null, primary key
#  titre         :string           not null
#  type_projet   :string           not null
#  description   :text             not null
#  image_url     :text
#  image_url_alt :string
#  date_debut    :date
#  date_fin      :date
#  client        :string
#  projet_lien   :string
#  github_lien   :string
#  couleur       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#
# Indexes
#
#  index_projets_on_slug   (slug) UNIQUE
#  index_projets_on_titre  (titre) UNIQUE
#

class Projet < ApplicationRecord
  include PgSearch::Model

  extend FriendlyId

  friendly_id :titre, use: %i[slugged history]

  TYPE_PROJET = ["application web", "site vitrine", "site e-commerce", "autres", "saas"]

  validates :titre, presence: true, uniqueness: true
  validates :type_projet, presence: true, inclusion: { in: TYPE_PROJET }
  validates :description, presence: true, uniqueness: true

  has_many :outils_projets
  has_many :outils, through: :outils_projets

  scope :ordered, -> { order(Arel.sql("date_debut DESC NULLS LAST"), created_at: :desc, id: :desc) }

  pg_search_scope :search_projets,
                  against: %i[titre description type_projet],
                  using: {
                    tsearch: {
                      prefix: true
                    }
                  }

  def neighbors
    ids = self.class.ordered.ids
    index = ids.index(id)
    return [nil, nil] if index.nil?

    previous_projet = index.positive? ? self.class.find(ids[index - 1]) : nil
    next_projet = ids[index + 1] ? self.class.find(ids[index + 1]) : nil
    [previous_projet, next_projet]
  end

  def should_generate_new_friendly_id?
    titre_changed? || slug.blank?
  end

  def normalize_friendly_id(text)
    text.to_s
        .downcase
        .gsub(/[éèêë]/, "e")
        .gsub(/[àâä]/, "a")
        .gsub(/[îï]/, "i")
        .gsub(/[ôö]/, "o")
        .gsub(/[ûüù]/, "u")
        .gsub(/ç/, "c")
        .gsub(/[^a-z0-9]/, "-").squeeze("-")
        .gsub(/^-|-$/, "")
  end
end
