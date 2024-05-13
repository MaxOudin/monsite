class Outil < ApplicationRecord
  has_many :outils_projets
  has_many :projets, through: :outils_projets

  validates :nom, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true

end
