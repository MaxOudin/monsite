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

  describe ".search_articles" do
    it "trouve un article par son titre" do
      article = create(:article, titre: "PostgreSQL avancé", content: "<p>Texte neutre alpha.</p>")
      create(:article, titre: "Sujet différent", content: "<p>Texte neutre beta.</p>")

      expect(Article.search_articles("Postgre")).to contain_exactly(article)
    end

    it "trouve un article par son contenu" do
      article = create(:article, titre: "Titre neutre un", content: "<p>Un passage sur Tailwind uniquement ici.</p>")
      create(:article, titre: "Titre neutre deux", content: "<p>Un autre passage.</p>")

      expect(Article.search_articles("Tailwind")).to contain_exactly(article)
    end

    it "ignore le thème" do
      create(:article, theme: "Les performances", titre: "Sujet hors thème", content: "<p>Sans le mot recherché.</p>")

      expect(Article.search_articles("performances")).to be_empty
    end
  end

  describe "#reading_time_in_minutes" do
    it "compte au minimum une minute" do
      article = create(:article, content: "Un seul mot")
      expect(article.reading_time_in_minutes).to eq(1)
    end

    it "arrondit à la minute supérieure, à 200 mots par minute" do
      article = create(:article, content: Array.new(201, "mot").join(" "))
      expect(article.reading_time_in_minutes).to eq(2)
    end
  end

  describe "#related_articles" do
    it "privilégie le même thème, puis complète avec les plus récents" do
      current = create(:article, theme: "Autour du web", titre: "Article courant")
      same_theme = create(:article, theme: "Autour du web", titre: "Même thème")
      other = create(:article, theme: "Les performances", titre: "Autre thème")

      expect(current.related_articles).to eq([same_theme, other])
    end

    it "reste sur le même thème quand il y en a assez" do
      current = create(:article, theme: "Les performances", titre: "Article performances")
      earlier = create(:article, theme: "Les performances", titre: "Performance ancienne")
      later = create(:article, theme: "Les performances", titre: "Performance récente")
      create(:article, theme: "Autour du web", titre: "Hors thème")

      expect(current.related_articles).to eq([later, earlier])
    end
  end

  describe "slug (FriendlyId)" do
    it "génère un slug à partir du titre" do
      article = create(:article, titre: "Mon Super Article")
      expect(article.slug).to eq("mon-super-article")
    end
  end
end
