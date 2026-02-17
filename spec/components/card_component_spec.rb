# frozen_string_literal: true

require "rails_helper"

RSpec.describe CardComponent, type: :component do
  describe "avec un Projet" do
    let(:projet) { create(:projet, titre: "Mon Projet", type_projet: "application web", date_debut: Date.new(2025, 3, 1)) }

    it "affiche le titre" do
      rendered = render_inline(described_class.new(model: projet))
      expect(rendered.css("h2").text).to include("Mon Projet")
    end

    it "affiche la date formatée" do
      rendered = render_inline(described_class.new(model: projet))
      expect(rendered.text).to include("Mar 2025")
    end

    it "affiche le type de projet en badge" do
      rendered = render_inline(described_class.new(model: projet))
      expect(rendered.text).to include("Application Web")
    end

    it "génère un lien vers le projet" do
      rendered = render_inline(described_class.new(model: projet))
      expect(rendered.css("a").first["href"]).to eq("/projets/#{projet.slug}")
    end

    context "sans date" do
      let(:projet) { create(:projet, date_debut: nil) }

      it "affiche 'Projet récent'" do
        rendered = render_inline(described_class.new(model: projet))
        expect(rendered.text).to include("Projet récent")
      end
    end

    context "sans image" do
      let(:projet) { create(:projet, image_url: nil) }

      it "utilise le logo par défaut" do
        rendered = render_inline(described_class.new(model: projet))
        expect(rendered.css("div[style*='background-image']").first["style"]).to include("yellow_logo")
      end
    end
  end

  describe "avec un Article" do
    let(:article) { create(:article, titre: "Mon Article", theme: "Autour du web", created_at: Date.new(2025, 6, 15)) }

    it "affiche le titre" do
      rendered = render_inline(described_class.new(model: article))
      expect(rendered.css("h2").text).to include("Mon Article")
    end

    it "affiche la date de création" do
      rendered = render_inline(described_class.new(model: article))
      expect(rendered.text).to include("Jun 2025")
    end

    it "affiche le thème en badge" do
      rendered = render_inline(described_class.new(model: article))
      expect(rendered.text).to include("Autour du web")
    end

    it "génère un lien vers l'article" do
      rendered = render_inline(described_class.new(model: article))
      expect(rendered.css("a").first["href"]).to eq("/articles/#{article.slug}")
    end
  end
end