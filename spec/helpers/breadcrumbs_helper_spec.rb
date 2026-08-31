require "rails_helper"

RSpec.describe BreadcrumbsHelper, type: :helper do
  describe "#breadcrumbs" do
    it "commence toujours par l'accueil" do
      allow(helper).to receive(:controller_name).and_return("services")
      allow(helper).to receive(:action_name).and_return("index")

      crumbs = helper.breadcrumbs

      expect(crumbs.first[:name]).to eq("Accueil")
      expect(crumbs.first[:path]).to eq(root_path)
    end

    it "ajoute Projets et le titre sur la show d'un projet" do
      projet = create(:projet)
      assign(:projet, projet)
      allow(helper).to receive(:controller_name).and_return("projets")
      allow(helper).to receive(:action_name).and_return("show")

      expect(helper.breadcrumbs.map { |crumb| crumb[:name] }).to eq(["Accueil", "Projets", projet.titre])
    end

    it "ajoute Articles et le titre sur la show d'un article" do
      article = create(:article, titre: "Un article")
      assign(:article, article)
      allow(helper).to receive(:controller_name).and_return("articles")
      allow(helper).to receive(:action_name).and_return("show")

      expect(helper.breadcrumbs.map { |crumb| crumb[:name] }).to eq(["Accueil", "Articles", "Un article"])
    end
  end

  describe "#render_breadcrumbs" do
    it "rend un trail sémantique sans icône home ni chevron" do
      projet = create(:projet)
      assign(:projet, projet)
      allow(helper).to receive(:controller_name).and_return("projets")
      allow(helper).to receive(:action_name).and_return("show")

      html = helper.render_breadcrumbs

      expect(html).to include("Fil d'ariane")
      expect(html).to include("breadcrumb-link")
      expect(html).to include("bg-primary")
      expect(html).not_to include("fa-home")
      expect(html).not_to include("fa-chevron-right")
    end
  end
end
