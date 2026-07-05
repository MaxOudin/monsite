# == Schema Information
#
# Table name: services
#
#  id            :integer          not null, primary key
#  nom           :string
#  description   :text
#  icone_url     :text
#  icone_url_alt :string
#  couleur       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :service do
    sequence(:nom) { |n| "Service #{n}" }
    sequence(:description) { |n| "Description du service #{n}." }
    couleur { "#18435A" }
    icone_url { "https://example.com/icone.svg" }
    icone_url_alt { "Icône du service" }
  end
end
