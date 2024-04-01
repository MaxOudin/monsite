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
    expect(FactoryBot.build(:outil)).to be_valid
  end

  let(:outil) { FactoryBot.build(:outil) }

  describe "ActiveRecord associations" do
    it { expect(outil).to belong_to(:projet) }
  end
end
