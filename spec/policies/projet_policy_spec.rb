require 'rails_helper'

RSpec.describe ProjetPolicy, type: :policy do
  subject { described_class }

  let(:visiteur) { nil }
  let(:user)     { User.new }

  permissions :index?, :show? do
    it "autorise les visiteurs anonymes et connectés" do
      expect(subject).to permit(visiteur, Projet.new)
      expect(subject).to permit(user, Projet.new)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "refuse un visiteur anonyme" do
      expect(subject).not_to permit(visiteur, Projet.new)
    end

    it "autorise un utilisateur connecté" do
      expect(subject).to permit(user, Projet.new)
    end
  end

  describe "Scope" do
    it "renvoie tous les projets" do
      create(:projet, titre: "Projet A", description: "Description A.")
      create(:projet, titre: "Projet B", description: "Description B.")
      scope = ProjetPolicy::Scope.new(user, Projet.all).resolve
      expect(scope.count).to eq(2)
    end
  end
end
