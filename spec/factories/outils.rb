# == Schema Information
#
# Table name: outils
#
#  id            :bigint           not null, primary key
#  description   :text
#  icone_url     :string
#  icone_url_alt :string
#  nom           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  projet_id     :bigint
#
# Indexes
#
#  index_outils_on_projet_id  (projet_id)
#
# Foreign Keys
#
#  fk_rails_...  (projet_id => projets.id)
#
FactoryBot.define do
  factory :outil do
    nom { "Ruby On Rails" }
    description { "Ruby on Rails est un framework libre écrit en Ruby.
      Il suit le motif d'architecture logicielle Modèle Vue Controleur.
      Le langage de programmation Ruby et le framework Rails sont au cœur du développement de Surf.ai,
      assurant une base solide et une gestion efficace des données" }
    projet { association(:projet) }
  end
end
