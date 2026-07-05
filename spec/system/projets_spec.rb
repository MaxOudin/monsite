require 'rails_helper'

RSpec.describe "Projets", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "On arrive sur l'index projets" do
    @projet = FactoryBot.create(:projet)

    visit projets_path

    # Titre de la page
    expect(page).to have_content("Mes Projets")
    expect(page).to have_content("Découvrez mes réalisations récentes")

    # Titre d'un projet
    expect(page).to have_content("Test.Ai")

    # Footer
    expect(page).to have_content("Créé par Maxime Oudin développeur web Ruby on Rails à Bordeaux.")
  end

  it "On arrive sur la show du projet" do
    @projet = FactoryBot.create(:projet)

    visit projet_path(@projet)

    # Titre du projet
    expect(page).to have_content("Test.Ai")

    # Contenu de la page projet
    expect(page).to have_content("À propos du projet")

    # Bouton retour
    expect(page).to have_content("Retour aux projets")

    # Footer
    expect(page).to have_content("Créé par Maxime Oudin développeur web Ruby on Rails à Bordeaux.")
  end
end
