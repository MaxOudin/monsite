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

FactoryBot.define do
  factory :outil do
    sequence(:nom) { |n| "Outil #{n}" }
    sequence(:description) { |n| "Description de l'outil #{n}." }

    # Association N-N réelle (via outils_projets). Le modèle ne déclare pas de
    # belongs_to :projet — la colonne projet_id est un vestige (cf. branche 2).
    trait :with_projet do
      projets { [association(:projet)] }
    end
  end
end
