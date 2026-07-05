# == Schema Information
#
# Table name: sujets
#
#  id            :integer          not null, primary key
#  nom           :string           not null
#  description   :text             not null
#  numero        :integer          not null
#  couleur       :string
#  icone_url     :text
#  icone_url_alt :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_sujets_on_nom     (nom) UNIQUE
#  index_sujets_on_numero  (numero) UNIQUE
#

class Sujet < ApplicationRecord
  validates :nom, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true
  validates :numero, presence: true, uniqueness: true

end
