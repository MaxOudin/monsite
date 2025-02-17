# == Schema Information
#
# Table name: outils
#
#  id            :integer          not null, primary key
#  nom           :string
#  description   :text
#  icone_url     :string
#  icone_url_alt :string
#  projet_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_outils_on_projet_id  (projet_id)
#

class Outil < ApplicationRecord
  has_many :outils_projets
  has_many :projets, through: :outils_projets

  validates :nom, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true

end
