class Projet < ApplicationRecord
  validates :titre, presence: true, uniqueness: true
  validates :type_projet, presence: true, selection: { in: [:application_web, :site_vitrine, :site_e_commerce, :autres, :saas] }
  validates :description, presence: true

end
