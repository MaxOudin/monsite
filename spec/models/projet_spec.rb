# == Schema Information
#
# Table name: projets
#
#  id            :integer          not null, primary key
#  titre         :string
#  type_projet   :string
#  description   :text
#  image_url     :text
#  image_url_alt :string
#  date_debut    :date
#  date_fin      :date
#  client        :string
#  projet_lien   :string
#  github_lien   :string
#  couleur       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#
# Indexes
#
#  index_projets_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Projet, type: :model do
  it "a une factory valide" do
    expect(build(:projet)).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:titre) }
    it { is_expected.to validate_presence_of(:type_projet) }
    it { is_expected.to validate_presence_of(:description) }

    it "n'accepte qu'un type_projet de la liste autorisée" do
      expect(build(:projet, type_projet: "saas")).to be_valid
      expect(build(:projet, type_projet: "type inexistant")).not_to be_valid
    end

    it "refuse un titre dupliqué" do
      create(:projet, titre: "Projet unique")
      expect(build(:projet, titre: "Projet unique")).not_to be_valid
    end

    it "refuse une description dupliquée" do
      create(:projet, description: "Une description partagée.")
      expect(build(:projet, description: "Une description partagée.")).not_to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:outils_projets) }
    it { is_expected.to have_many(:outils).through(:outils_projets) }

    it "expose ses outils via la table de jointure" do
      projet = create(:projet)
      outil = create(:outil)
      projet.outils << outil
      expect(projet.outils).to include(outil)
    end
  end

  describe "slug (FriendlyId)" do
    it "génère un slug normalisé sans accents" do
      projet = create(:projet, titre: "Éléphant Doré")
      expect(projet.slug).to eq("elephant-dore")
    end
  end
end
