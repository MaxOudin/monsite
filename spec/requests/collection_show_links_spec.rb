require "rails_helper"

RSpec.describe "Liens des index vers les fiches", type: :request do
  describe "GET /articles" do
    it "ouvre la fiche en navigation complète hors du turbo-frame" do
      article = create(:article, titre: "Mon article de test")

      get articles_path

      document = response.parsed_body
      form = document.at_css("form[action='#{articles_path}']")
      expect(form["data-turbo-frame"]).to eq("collection_results")

      link = card_link(response.body, article_path(article))
      expect(results_frame(response.body)["target"]).to eq("_top")
      expect(link["data-turbo-frame"]).to be_nil

      get link["href"]

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Mon article de test", "Retour aux articles")
    end
  end

  describe "GET /projets" do
    it "ouvre la fiche en navigation complète hors du turbo-frame" do
      projet = create(:projet, titre: "Atelier céramique")

      get projets_path

      link = card_link(response.body, projet_path(projet))
      expect(results_frame(response.body)["target"]).to eq("_top")
      expect(link["data-turbo-frame"]).to be_nil

      get link["href"]

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Atelier céramique")
      expect(response.body).to include("Retour aux projets")
    end
  end

  def results_frame(html)
    frame = Nokogiri::HTML(html).at_css("turbo-frame#collection_results")
    expect(frame).to be_present
    frame
  end

  def card_link(html, href)
    link = results_frame(html).at_css(%(a[href="#{href}"]))
    expect(link).to be_present
    link
  end
end
