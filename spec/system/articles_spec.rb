require "rails_helper"

RSpec.describe "Articles", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "On arrive sur l'index articles" do
    create(:article, titre: "Mon article de test")

    visit articles_path

    expect(page).to have_content("Mes Articles")
    expect(page).to have_content("Découvrez mes articles sur le développement web et mes expériences")
    expect(page).to have_content("Mon article de test")
    expect(page).to have_content("Créé par Maxime Oudin développeur web Ruby on Rails à Bordeaux.")
  end

  it "affiche le fil d'ariane sur la show d'un article" do
    article = create(:article, titre: "Mon article de test")

    visit article_path(article)

    expect(page).to have_css("nav[aria-label=\"Fil d'ariane\"]")
    expect(page).to have_link("Accueil", href: root_path)
    expect(page).to have_link("Articles", href: articles_path)
    expect(page).to have_content("Mon article de test")
  end
end
