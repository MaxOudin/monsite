class Projet < ApplicationRecord
  TYPE_PROJET = ["application web", "site vitrine", "site e-commerce", "autres", "saas"]

  validates :titre, presence: true, uniqueness: true
  validates :type_projet, presence: true, inclusion: { in: TYPE_PROJET }
  validates :description, presence: true, uniqueness: true

  has_many :outils_projets
  has_many :outils, through: :outils_projets

end
