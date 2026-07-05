require 'rails_helper'

RSpec.describe ArticlePolicy, type: :policy do
  subject { described_class }

  let(:visiteur) { nil }
  let(:user)     { User.new }

  permissions :index?, :show? do
    it "autorise les visiteurs anonymes et connectés" do
      expect(subject).to permit(visiteur, Article.new)
      expect(subject).to permit(user, Article.new)
    end
  end

  permissions :create?, :update?, :destroy? do
    it "refuse un visiteur anonyme" do
      expect(subject).not_to permit(visiteur, Article.new)
    end

    it "autorise un utilisateur connecté" do
      expect(subject).to permit(user, Article.new)
    end
  end

  describe "Scope" do
    it "renvoie tous les articles" do
      create_list(:article, 2)
      scope = ArticlePolicy::Scope.new(user, Article.all).resolve
      expect(scope.count).to eq(2)
    end
  end
end
