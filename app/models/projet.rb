class Projet < ApplicationRecord
  validates :titre, presence: true, uniqueness: true
  validates :type_projet, presence: true, inclusion: { in: ["application web", "site vitrine", "site e-commerce", "autres", "saas"] }
  validates :description, presence: true, uniqueness: true

  has_many :outils

end

