require 'rails_helper'

RSpec.describe "Projets", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "On arrive sur l'index projets" do
    @projet = FactoryBot.create(:projet)

    visit projets_path

    # Titre de la page
    expect(page).to have_content("Mes derniers projets")

    # Titre d'un projet
    expect(page).to have_content("Test.Ai")

    # Bouton En savoir plus pour aller vers la show
    expect(page).to have_content("En savoir plus")

    # Bouton retour
    expect(page).to have_content("Retour")

    # Footer
    expect(page).to have_content("Maxime Oudin, développeur web Ruby On Rails à Bordeaux")
  end

  it "On arrive sur la show du projet" do
    @projet = FactoryBot.create(:projet)

    visit projet_path(@projet) # Utilisez projet_path au lieu de projets_path

    # Titre du projet
    expect(page).to have_content("Projet: Test.Ai")

    # Voir les outils utilisés
    expect(page).to have_content("cliquer sur l'outil pour en savoir plus")

    # Bouton retour
    expect(page).to have_content("Retour")

    # Footer
    expect(page).to have_content("Maxime Oudin, développeur web Ruby On Rails à Bordeaux")

  end
end
