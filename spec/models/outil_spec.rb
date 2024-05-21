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
require 'rails_helper'
# belongs_to :projet
# nom "Ruby On Rails"
# description "Ruby on Rails est un framework libre écrit en Ruby.
#   Il suit le motif d'architecture logicielle Modèle Vue Controleur.
#   Le langage de programmation Ruby et le framework Rails sont au cœur du développement de Surf.ai,
#   assurant une base solide et une gestion efficace des données",
# projet { association(:projet) }

RSpec.describe Outil, type: :model do
  it "has a valid factory" do
    outil = FactoryBot.create(:outil)
    expect(outil).to be_valid
  end

  describe "ActiveRecord associations outil - projet" do
    let(:outil) { FactoryBot.create(:outil) }

    it "belongs to a projet" do
      association = described_class.reflect_on_association(:projet)
      expect(association.macro).to eq :belongs_to
    end
  end
end
