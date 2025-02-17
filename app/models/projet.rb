# == Schema Information
#
# Table name: projets
#
#  id            :integer          not null, primary key
#  titre         :string
#  type_projet   :string
#  description   :text
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
#  index_projets_on_slug  (slug) UNIQUE
#

class Projet < ApplicationRecord
  extend FriendlyId
  friendly_id :titre, use: [:slugged, :history]

  TYPE_PROJET = ["application web", "site vitrine", "site e-commerce", "autres", "saas"]

  validates :titre, presence: true, uniqueness: true
  validates :type_projet, presence: true, inclusion: { in: TYPE_PROJET }
  validates :description, presence: true, uniqueness: true

  has_many :outils_projets
  has_many :outils, through: :outils_projets

  def should_generate_new_friendly_id?
    titre_changed? || slug.blank?
  end

  def normalize_friendly_id(text)
    text.to_s
        .downcase
        .gsub(/[éèêë]/, 'e')
        .gsub(/[àâä]/, 'a')
        .gsub(/[îï]/, 'i')
        .gsub(/[ôö]/, 'o')
        .gsub(/[ûüù]/, 'u')
        .gsub(/[ç]/, 'c')
        .gsub(/[^a-z0-9]/, '-')
        .gsub(/-+/, '-')
        .gsub(/^-|-$/, '')
  end
end
