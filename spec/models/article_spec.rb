# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  titre      :string           not null
#  image_url  :string           not null
#  image_alt  :string           not null
#  couleur    :string           not null
#  theme      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#
# Indexes
#
#  index_articles_on_slug   (slug) UNIQUE
#  index_articles_on_titre  (titre) UNIQUE
#

require 'rails_helper'

RSpec.describe Article, type: :model do
  it "a une factory valide" do
    expect(build(:article)).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:titre) }
    it { is_expected.to validate_presence_of(:image_url) }
    it { is_expected.to validate_presence_of(:image_alt) }
    it { is_expected.to validate_presence_of(:couleur) }
    it { is_expected.to validate_presence_of(:theme) }

    it "exige un contenu (ActionText)" do
      expect(build(:article, content: nil)).not_to be_valid
    end

    it "refuse un titre dupliqué" do
      create(:article, titre: "Mon article")
      expect(build(:article, titre: "Mon article")).not_to be_valid
    end

    it "n'accepte qu'un thème de la liste autorisée" do
      expect(build(:article, theme: "Autour du web")).to be_valid
      expect(build(:article, theme: "Thème inexistant")).not_to be_valid
    end
  end

  describe "#couleur_du_theme" do
    it "renvoie la couleur associée au thème" do
      article = build(:article, theme: "Ecologie et développement web")
      expect(article.couleur_du_theme).to eq("#386641")
    end
  end

  describe ".count_by_theme" do
    it "compte les articles regroupés par thème" do
      create(:article, theme: "Autour du web")
      create(:article, theme: "Autour du web")
      create(:article, theme: "Les performances")

      expect(Article.count_by_theme).to eq(
        "Autour du web" => 2,
        "Les performances" => 1
      )
    end
  end

  describe "slug (FriendlyId)" do
    it "génère un slug à partir du titre" do
      article = create(:article, titre: "Mon Super Article")
      expect(article.slug).to eq("mon-super-article")
    end
  end
end
