require "rails_helper"

RSpec.describe "Recherche des collections", type: :request do
  describe "GET /articles" do
    it "filtre le titre et le contenu à partir de 2 caractères" do
      by_title = create(:article, titre: "Rails patterns", content: "<p>Texte neutre.</p>")
      by_content = create(:article, titre: "Brouillon libre", content: "<p>Motif Stimulus unique.</p>")
      other = create(:article, titre: "Jardinage urbain", content: "<p>Autre texte.</p>")

      get articles_path, params: { query: "Ra" }

      expect(response).to be_successful
      expect(response.body).to include("live-search")
      expect(response.body).to include('id="collection_results"')
      expect(response.body).to include(by_title.titre)
      expect(response.body).not_to include(other.titre)

      get articles_path, params: { query: "Stimulus" }

      expect(response.body).to include(by_content.titre)
      expect(response.body).not_to include(other.titre)

      get articles_path, params: { query: "R" }

      expect(response.body).to include(by_title.titre)
      expect(response.body).to include(by_content.titre)
      expect(response.body).to include(other.titre)
      expect(response.body).not_to include("résultat")
    end

    it "ignore le thème" do
      create(:article, theme: "Les performances", titre: "Sujet hors thème", content: "<p>Sans le mot recherché.</p>")

      get articles_path, params: { query: "performances" }

      expect(response.body).to include("Aucun résultat")
      expect(response.body).not_to include("Sujet hors thème")
    end

    it "tronque la requête à #{MAX_SEARCH_LENGTH} caractères" do
      article = create(:article, titre: "Rails patterns courts", content: "<p>Texte neutre.</p>")
      create(:article, titre: "Jardinage urbain", content: "<p>Autre texte.</p>")

      get articles_path, params: { query: "Rails patterns courts et beaucoup trop long" }

      expect(response).to be_successful
      expect(response.body).to include(%(maxlength="#{MAX_SEARCH_LENGTH}"))
      expect(response.body).to include(article.titre)
      expect(response.body).to include("Rails patterns court")
      expect(response.body).not_to include("et beaucoup trop long")
    end
  end

  describe "GET /projets" do
    it "filtre le titre, la description et le type à partir de 2 caractères" do
      by_title = create(:projet, titre: "Atelier céramique", description: "Présentation d'un lieu de création.")
      by_type = create(:projet, titre: "Plateforme interne", type_projet: "saas",
                                description: "Outil de suivi des commandes clients.")
      other = create(:projet, titre: "Jardin partagé", type_projet: "autres",
                              description: "Un espace collectif en ville.")

      get projets_path, params: { query: "Atelier" }

      expect(response).to be_successful
      expect(response.body).to include(by_title.titre)
      expect(response.body).not_to include(other.titre)

      get projets_path, params: { query: "saas" }

      expect(response.body).to include(by_type.titre)
      expect(response.body).not_to include(other.titre)

      get projets_path, params: { query: "A" }

      expect(response.body).to include(by_title.titre)
      expect(response.body).to include(by_type.titre)
      expect(response.body).to include(other.titre)
    end
  end
end
