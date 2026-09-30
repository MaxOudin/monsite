# == Schema Information
#
# Table name: projets
#
#  id            :integer          not null, primary key
#  titre         :string           not null
#  type_projet   :string           not null
#  description   :text             not null
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
#  index_projets_on_slug   (slug) UNIQUE
#  index_projets_on_titre  (titre) UNIQUE
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

  describe ".search_projets" do
    it "trouve un projet par son titre" do
      projet = create(:projet, titre: "Atelier céramique", description: "Présentation d'un lieu de création.")
      create(:projet, titre: "Outil interne", description: "Tableau de bord pour l'équipe.")

      expect(Projet.search_projets("Atelier")).to contain_exactly(projet)
    end

    it "trouve un projet par sa description" do
      projet = create(:projet, titre: "Vitrine atelier", description: "Une page pour les créations en grès.")
      create(:projet, titre: "Suivi commandes", description: "Tableau de bord des commandes clients.")

      expect(Projet.search_projets("grès")).to contain_exactly(projet)
    end

    it "trouve un projet par son type" do
      projet = create(:projet, titre: "Plateforme interne", type_projet: "saas", description: "Outil de suivi des commandes clients.")
      create(:projet, titre: "Site institutionnel", type_projet: "site vitrine", description: "Présentation de l'entreprise.")

      expect(Projet.search_projets("saas")).to contain_exactly(projet)
    end

    it "ignore le nom des outils associés" do
      projet = create(:projet, titre: "Projet nu", description: "Description sans outil nommé.")
      projet.outils << create(:outil, nom: "KubernetesUnique")

      expect(Projet.search_projets("KubernetesUnique")).to be_empty
    end
  end

  describe ".ordered" do
    it "classe les projets du plus récent au plus ancien, et les dates vides en dernier" do
      recent = create(:projet, titre: "Récent", description: "Description du projet récent.", date_debut: Date.new(2025, 6, 1))
      older = create(:projet, titre: "Ancien", description: "Description du projet ancien.", date_debut: Date.new(2024, 1, 1))
      undated = create(:projet, titre: "Sans date", description: "Description sans date.", date_debut: nil)

      expect(Projet.ordered).to eq([recent, older, undated])
    end
  end

  describe "#neighbors" do
    it "renvoie le projet plus récent puis le projet plus ancien" do
      recent = create(:projet, titre: "Récent voisin", description: "Description récente voisine.", date_debut: Date.new(2025, 6, 1))
      current = create(:projet, titre: "Courant", description: "Description du projet courant.", date_debut: Date.new(2024, 6, 1))
      older = create(:projet, titre: "Ancien voisin", description: "Description ancienne voisine.", date_debut: Date.new(2023, 1, 1))

      expect(current.neighbors).to eq([recent, older])
      expect(recent.neighbors).to eq([nil, current])
      expect(older.neighbors).to eq([current, nil])
    end
  end

  describe "slug (FriendlyId)" do
    it "génère un slug normalisé sans accents" do
      projet = create(:projet, titre: "Éléphant Doré")
      expect(projet.slug).to eq("elephant-dore")
    end
  end
end
