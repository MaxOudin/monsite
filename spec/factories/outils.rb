# == Schema Information
#
# Table name: outils
#
#  id            :integer          not null, primary key
#  nom           :string
#  description   :text
#  icone_url     :string
#  icone_url_alt :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :outil do
    sequence(:nom) { |n| "Outil #{n}" }
    sequence(:description) { |n| "Description de l'outil #{n}." }

    # Association N-N réelle (via outils_projets). La colonne projet_id orpheline
    # a été supprimée en branche 2 (cf. documentation/09).
    trait :with_projet do
      projets { [association(:projet)] }
    end
  end
end
