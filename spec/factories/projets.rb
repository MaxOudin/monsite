# == Schema Information
#
# Table name: projets
#
#  id            :bigint           not null, primary key
#  client        :string
#  couleur       :string
#  date_debut    :date
#  date_fin      :date
#  description   :text
#  github_lien   :string
#  image_url     :text
#  image_url_alt :string
#  projet_lien   :string
#  titre         :string
#  type_projet   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# has_many :outils

FactoryBot.define do
  factory :projet do
    titre { "Test.Ai" }
    type_projet { "application web" }
    description { "Surf.Ai est une plateforme de location de planches de surf entre particuliers.
      Je peux à la fois proposer mes planches à la location et louer des planches de surf.
      En tant qu'utilisateur, je peux donc créer une planche avec un titre, un descriptif, un prix par jour et lui ajouter plusieurs photos pour la proposer à la location.
      Depuis l'accueil, je peux voir les planches disponibles par planche avec la moyenne des notes laissés par les précédents locataires et chacune géocalisée sur la carte.
      Il est possible de rechercher plus précisemment des planches de surf en fonction de leur type, pour trouver celle qui me correspond.
      Les locataires peuvent consulter les évaluations et avis des clients précédents, assurant des choix éclairés.
      Avant la confirmer la réservation la plateforme Surf.ai vous montre le récapitulatif de l'offre.
      Vous pourrez y retrouver les détails de votre choix pour vérifier notamment des dates spécifiques et le budget total.
      Surf.Ai offre à chaque utilisateur un espace présentant l'historique de réservations et de locations.
      Cela favorisant l'engagement communautaire grâce aux évaluations et aux avis post-location, améliorant ainsi l'expérience des utilisateurs." }
    image_url { "https://res.cloudinary.com/dyleaesxc/image/upload/v1698925883/production/66xsp347pg4llarxvcikcys3depg.png" }
    image_url_alt { "Capture ecran du projet Surf.ai" }
    date_debut { "2023-08-21" }
    date_fin { "2023-08-25" }
    client { "Projet sprint 1 semaine" }
    github_lien { "https://github.com/MaxOudin/surf-ai/blob/master/README.md" }
    couleur { "#6AE897" }
  end
end
