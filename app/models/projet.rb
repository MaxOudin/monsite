# == Schema Information
#
# Table name: projets
#
#  id            :bigint           not null, primary key
#  client        :string
#  couleur       :string
#  date_debut    :date
#  date_fin      :date
#  description   :text
#  github_lien   :string
#  image_url     :text
#  image_url_alt :string
#  projet_lien   :string
#  titre         :string
#  type_projet   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Projet < ApplicationRecord
  TYPE_PROJET = ["application web", "site vitrine", "site e-commerce", "autres", "saas"]

  validates :titre, presence: true, uniqueness: true
  validates :type_projet, presence: true, inclusion: { in: TYPE_PROJET }
  validates :description, presence: true, uniqueness: true

  has_many :outils_projets
  has_many :outils, through: :outils_projets

end
