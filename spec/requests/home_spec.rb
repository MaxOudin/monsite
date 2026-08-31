require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "affiche le hero avec les stats et les CTA, sans logo en fond" do
      create(:projet)
      create(:article)

      get root_path

      expect(response).to be_successful
      expect(response.body).to include("Je transforme vos idées en solutions web sur-mesure")
      expect(response.body).to include("#{Date.current.year - 2023} ans")
      expect(response.body).to include("expérience")
      expect(response.body).to include("Satisfaction client")
      expect(response.body).to include("Me contacter")
      expect(response.body).to include("Voir mes réalisations")
      expect(response.body).to include("bg-primary")
      expect(response.body).to include("text-secondary")
      expect(response.body).to include("rounded-full")
      expect(response.body).to include("rounded-xl")
      expect(response.body).to include("shadow-md")
      expect(response.body).not_to include("hero-logo-bg")
      expect(response.body.scan("yellow_logo").size).to eq(1)
    end

    it "lie les stats projets et articles vers leurs index" do
      get root_path

      expect(response.body).to include(projets_path)
      expect(response.body).to include(articles_path)
    end
  end
end
