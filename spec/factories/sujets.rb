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

FactoryBot.define do
  factory :sujet do
    sequence(:nom) { |n| "Sujet #{n}" }
    sequence(:description) { |n| "Description du sujet #{n}." }
    sequence(:numero) { |n| n }
    couleur { "#18435A" }
    icone_url { "https://example.com/icone.svg" }
    icone_url_alt { "Icône du sujet" }
  end
end
