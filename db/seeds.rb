# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).


# --------------------- RESET -------------------------------
# --------------------- RESET -------------------------------

# Reset database
if Outil.last != nil
  Outil.destroy_all
  puts "Reset outils"
end

if Projet.last != nil
  Projet.destroy_all
  puts "Reset projets"
end

puts "Reset database"

# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------

# Create project
surf = Projet.create(
  titre: "Surf.Ai",
  type_projet: "application web",
  description: "Surf.Ai est une plateforme de location de planches de surf entre particuliers.
  Je peux à la fois proposer mes planches à la location et louer des planches de surf.
  En tant qu'utilisateur, je peux donc créer une planche avec un titre, un descriptif, un prix par jour et lui ajouter plusieurs photos pour la proposer à la location.
  Depuis l'accueil, je peux voir les planches disponibles par planche avec la moyenne des notes laissés par les précédents locataires et chacune géocalisée sur la carte.
  Il est possible de rechercher plus précisemment des planches de surf en fonction de leur type, pour trouver celle qui me correspond.
  Les locataires peuvent consulter les évaluations et avis des clients précédents, assurant des choix éclairés.
  Avant la confirmer la réservation la plateforme Surf.ai vous montre le récapitulatif de l'offre.
  Vous pourrez y retrouver les détails de votre choix pour vérifier notamment des dates spécifiques et le budget total.
  Surf.Ai offre à chaque utilisateur un espace présentant l'historique de réservations et de locations.
  Cela favorisant l'engagement communautaire grâce aux évaluations et aux avis post-location, améliorant ainsi l'expérience des utilisateurs.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1698925883/production/66xsp347pg4llarxvcikcys3depg.png",
  image_url_alt: "Capture ecran du projet Surf.ai",
  date_debut: "2023-08-21",
  date_fin: "2023-08-25",
  client: "Projet sprint 1 semaine",
  github_lien: "https://github.com/MaxOudin/surf-ai/blob/master/README.md",
  couleur: "#6AE897"
  )

puts "Projet surf créé"

# --------------------- OUTILS pour projet -------------------------------
# --------------------- OUTILS pour projet -------------------------------
# --------------------- OUTILS pour projet -------------------------------


ruby_surf = Outil.create(
  nom: "Ruby On Rails",
  description: "Ruby on Rails est un framework libre écrit en Ruby.
  Il suit le motif d'architecture logicielle Modèle Vue Controleur.
  Le langage de programmation Ruby et le framework Rails sont au cœur du développement de Surf.ai,
  assurant une base solide et une gestion efficace des données",
  projet: surf
)

js_stimulus_surf = Outil.create(
  nom: "JavaScript et Stimulus",
  description: "L'utilisation de JavaScript, combinée au framework Stimulus,
  permet une interface utilisateur interactive et réactive,
  améliorant ainsi l'expérience utilisateur.",
  projet: surf
)

mapbox_surf = Outil.create(
  nom: "Mapbox",
  description: "Mapbox est utilisé pour la visualisation des cartes,
  L'intégration de Mapbox apporte une dimension visuelle.
  Elle permet aux utilisateurs de localiser et de visualiser les planches disponibles,
  facilitant ainsi le choix des emplacements de location.",
  projet: surf
)

cloudinary_surf = Outil.create(
  nom: "Cloudinary",
  description: "Cloudinary est utilisé pour le stockage des images,
  assurant une gestion efficace des images et des performances optimales.",
  projet: surf
)

flatpickr_surf = Outil.create(
  nom: "Flatpickr",
  description: "Flatpickr est intégré pour faciliter la sélection de dates,
  améliorant l'expérience de l'utilisateur lors de l'entrée des informations.",
  projet: surf
)

bootstrap_surf = Outil.create(
  nom: "Bootstrap",
  description: "Le framework Bootstrap garantit un design réactif et esthétiquement plaisant,
  contribuant à une interface utilisateur moderne.",
  projet: surf
)

star_rating_surf = Outil.create(
  nom: "Star Rating",
  description: "L'intégration de Star Rating permet aux utilisateurs de noter les planches de surf,
  favorisant l'engagement communautaire et améliorant l'expérience de surf.",
  projet: surf
)

tom_select_surf = Outil.create(
  nom: "Tom Select",
  description: "Tom Select est intégré pour faciliter la sélection des emplacements,
  améliorant l'expérience de l'utilisateur lors de l'entrée des informations.",
  projet: surf
)

devise_surf = Outil.create(
  nom: "Devise",
  description: "L'utilisation de Devise simplifie l'implémentation de fonctionnalités liées à l'authentification et à la gestion des utilisateurs.",
  projet: surf
)

github_surf = Outil.create(
  nom: "GitHub",
  description: "La plateforme GitHub est utilisée pour le suivi et la gestion du code source,
  favorisant la collaboration au sein de l'équipe de développement.",
  projet: surf
)

heroku_surf = Outil.create(
  nom: "Heroku",
  description: "Heroku est utilisé comme plateforme d'hébergement,
  assurant la disponibilité et la stabilité de Surf.ai.",
  projet: surf
)

trello_surf = Outil.create(
  nom: "Trello, Slack",
  description: "Trello est utilisé pour la gestion de projet,
  tandis que Slack facilite la communication au sein de l'équipe de développement.",
  projet: surf
)

puts "Outils surf créés"

# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------

surviv = Projet.create(
  titre: "Surviv.Ai",
  type_projet: "saas",
  description: "Surviv.Ai est un logiciel de téléchargement et gestion de factures.
  Le but du SaaS (Software As A Service) est d'éliminer les tâches répétitives et chronophages.
  Nous avons choisi d'autimatiser le dépôt de factures et simplifiant la visualisation de leur statut.
  Surviv.Ai permet aux utilisateurs ayant créé un compte, d'enregistrer les factures en téléchargeant le fichier pdf.
  Notre technologie lit le pdf et extrait de façon automatisée les détails cruciaux pour l'enregistrer dans la base de données.
  Cette extraction est aussi possible à travers les pièces jointes aux e-mails.
  En effet, notre technologie est aussi capable de lire le pdf inclut en pièce jointe et d'extraire les informations.
  Les utilisateurs peuvent ensuite visualiser les factures enregistrées et leur statut sous différents aspects.
  Il est aussi possible de voir l'historique des relances faites pour chaque facture.
  Surviv.Ai offre à chaque utilisateur un espace présentant le tableau de bord.
  Ce tableau de bord présente les informations financières clés autour des délais de paiement.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1696419032/Capture_d_e%CC%81cran_2023-10-03_a%CC%80_14.32.06_jwjcda.png",
  image_url_alt: "Capture ecran du projet Survivai, vue des factures en cartes",
  date_debut: "2023-09-04",
  date_fin: "2023-09-08",
  client: "Projet personnel",
  github_lien: "https://github.com/MaxOudin/-surviv-ai/blob/master/README.md",
  couleur: "#90CAFC"
  )

puts "Projet surviv créé"


# --------------------- OUTILS pour projet -------------------------------
# --------------------- OUTILS pour projet -------------------------------
# --------------------- OUTILS pour projet -------------------------------

ruby_surviv = Outil.create(
  nom: "Ruby On Rails",
  description: "Ruby on Rails est un framework libre écrit en Ruby.
  Il suit le motif d'architecture logicielle Modèle Vue Controleur.
  Le langage de programmation Ruby et le framework Rails sont au cœur du développement de Surviv.ai,
  assurant une base solide et une gestion efficace des données",
  projet: surviv
)

js_stimulus_surviv = Outil.create(
  nom: "JavaScript et Stimulus",
  description: "L'utilisation de JavaScript, combinée au framework Stimulus,
  permet une interface utilisateur interactive et réactive,
  améliorant ainsi l'expérience utilisateur.",
  projet: surviv
)

redis_surviv = Outil.create(
  nom: "Redis",
  description: "Le système de stockage clé-valeur Redis est intégré pour des performances optimales,
  offrant une gestion rapide et efficace des données.",
  projet: surviv
)

mindee_surviv = Outil.create(
  nom: "Mindee API",
  description: "L'API Mindee est utilisée pour l'extraction automatisée des détails des factures à partir de documents PDF,
  optimisant ainsi le processus de gestion des factures.",
  projet: surviv
)

zapier_surviv = Outil.create(
  nom: "Zapier",
  description: "L'intégration de Zapier facilite l'automatisation des tâches,
  améliorant l'efficacité opérationnelle de Surviv.ai.",
  projet: surviv
)

postgresql_surviv = Outil.create(
  nom: "PostgreSQL",
  description: "Les bases de données SQL sont utilisées pour le stockage et la gestion structurée des données,
  assurant la stabilité et la fiabilité du système.",
  projet: surviv
)

flatpickr_surviv = Outil.create(
  nom: "Flatpickr",
  description: "Flatpickr est intégré pour faciliter la sélection de dates,
  améliorant l'expérience de l'utilisateur lors de l'entrée des informations.",
  projet: surviv
)

bootstrap_surviv = Outil.create(
  nom: "Bootstrap",
  description: "Le framework Bootstrap garantit un design réactif et esthétiquement plaisant,
  contribuant à une interface utilisateur moderne.",
  projet: surviv
)

devise_surviv = Outil.create(
  nom: "Devise",
  description: "L'utilisation de Devise simplifie l'implémentation de fonctionnalités liées à l'authentification et à la gestion des utilisateurs.",
  projet: surviv
)

github_surviv = Outil.create(
  nom: "GitHub",
  description: "La plateforme GitHub est utilisée pour le suivi et la gestion du code source,
  favorisant la collaboration au sein de l'équipe de développement.",
  projet: surviv
)

heroku_surviv = Outil.create(
  nom: "Heroku",
  description: "Heroku est utilisé comme plateforme d'hébergement,
  assurant la disponibilité et la stabilité de Surviv.ai.",
  projet: surviv
)

trello_surviv = Outil.create(
  nom: "Trello, Slack",
  description: "Trello est utilisé pour la gestion de projet,
  tandis que Slack facilite la communication au sein de l'équipe de développement.",
  projet: surviv
)

puts "Outils surviv créés"

# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------

# Create project

music = Projet.create(
  titre: 'MaxMusic - Shazam API',
  type_projet: "application web",
  description: "Voici MaxMusic, outil de recherches de Music par mots clés.
  Vous pouvez utiliser le formulaire de recherche pour retrouver des mots à partir du titre d'une chanson.
  Ma mémoire me fait parfois défaut, et je connais approximativement le titre de la musique...
  J'ai pensé qu'il serait agréable de trouver directement la pochette de l'album, l'artiste et d'avoir la possibilité d'écouter la musique pour être sûr de la chanson que je recherche, sans avoir à naviguer uniquement en tapant une fois les mots-clés.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1697205527/home_g3tvhj.png",
  image_url_alt: "Capture ecran du projet MaxMusic, outil de recherche de musiques via API Shazam",
  date_debut: "2023-09-24",
  date_fin: "2023-10-08",
  client: "Projet personnel",
  github_lien: 'https://github.com/MaxOudin/Maxmusic#readme',
  couleur: "#6AE2C6"
  )

  puts "Projet music créé"

# --------------------- OUTILS pour projet -------------------------------
# --------------------- OUTILS pour projet -------------------------------
# --------------------- OUTILS pour projet -------------------------------

ruby_music = Outil.create(
  nom: "Ruby On Rails",
  description: "Ruby on Rails est un framework libre écrit en Ruby.
  Il suit le motif d'architecture logicielle Modèle Vue Controleur.
  Le langage de programmation Ruby et le framework Rails sont au cœur du développement de MaxMusic,
  assurant une base solide et une gestion efficace des données",
  projet: music
)

js_stimulus_music = Outil.create(
  nom: "JavaScript et Stimulus",
  description: "L'utilisation de JavaScript, combinée au framework Stimulus,
  permet une interface utilisateur interactive et réactive,
  améliorant ainsi l'expérience utilisateur.",
  projet: music
)

shazam_music = Outil.create(
  nom: "Shazam API",
  description: "L'API Shazam est utilisée pour la recherche de musiques,
  optimisant ainsi le processus de recherche de musiques.",
  projet: music
)

bootstrap_music = Outil.create(
  nom: "Bootstrap",
  description: "Le framework Bootstrap garantit un design réactif et esthétiquement plaisant,
  contribuant à une interface utilisateur moderne.",
  projet: music
)

postman = Outil.create(
  nom: "Postman & API REST",
  description: "Postman est utilisé pour tester les API REST,
  assurant la stabilité et la fiabilité du système.",
  projet: music
)

github_music = Outil.create(
  nom: "GitHub",
  description: "La plateforme GitHub est utilisée pour le suivi et la gestion du code source,
  favorisant la collaboration au sein de l'équipe de développement.",
  projet: music
)

puts "Outils music créés"



  ## Create services

#   create_table "services", force: :cascade do |t|
#     t.string "nom"
#     t.text "description"
#     t.text "icone_url"
#     t.string "icone_url_alt"
#     t.string "couleur"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#   end


# # Create sujets
#   create_table "sujets", force: :cascade do |t|
#     t.string "nom"
#     t.text "description"
#     t.integer "numero"
#     t.string "couleur"
#     t.text "icone_url"
#     t.string "icone_url_alt"
#     t.datetime "created_at", null: false
#     t.datetime "updated_at", null: false
#   end
