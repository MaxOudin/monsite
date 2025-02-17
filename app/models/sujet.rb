# == Schema Information
#
# Table name: sujets
#
#  id            :integer          not null, primary key
#  nom           :string
#  description   :text
#  numero        :integer
#  couleur       :string
#  icone_url     :text
#  icone_url_alt :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Sujet < ApplicationRecord
  validates :nom, presence: true, uniqueness: true
  validates :description, presence: true, uniqueness: true
  validates :numero, presence: true, uniqueness: true

end
