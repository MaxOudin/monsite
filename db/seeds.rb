# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).


# --------------------- RESET -------------------------------
# --------------------- RESET -------------------------------

# Reset database
Projet.destroy_all
puts "Reset database"

# Create project
surf = Projet.create(
  titre: "Surf.ai",
  type_projet: "application web",
  description: "Surf.Ai est une plateforme de location de planches de surf entre particuliers.
  Elle connecte les passionnés de surf, facilitant des recherches simples par type et emplacement, avec des descriptions détaillées.
  Les locataires peuvent consulter les évaluations des clients précédents, assurant des choix éclairés.
  Le processus de réservation intuitif permet aux utilisateurs de réserver des planches de surf pour des dates spécifiques.
  Surf.Ai offre un récapitulatif des réservations et un hub centralisé pour la gestion des réservations,
  favorisant l'engagement communautaire grâce aux évaluations et aux avis post-location, améliorant ainsi l'expérience de surf.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1698925883/production/66xsp347pg4llarxvcikcys3depg.png",
  image_url_alt: "Capture ecran du projet Surf.ai",
  date_debut: "2023-08-21",
  date_fin: "2023-08-25",
  client: "Projet personnel",
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
  icon_url:"",
  icon_url_alt:"Logo Ruby on Rails",
  projet: surf
)

js_stimulus_surf = Outil.create(
  nom: "JavaScript et Stimulus",
  description: "L'utilisation de JavaScript, combinée au framework Stimulus,
  permet une interface utilisateur interactive et réactive,
  améliorant ainsi l'expérience utilisateur.",
  icon_url:"",
  icon_url_alt:"Logo JavaScript",
  projet: surf
)

mapbox_surf = Outil.create(
  nom: "Mapbox",
  description: "Mapbox est utilisé pour la visualisation des cartes,
  L'intégration de Mapbox apporte une dimension visuelle.
  Elle permet aux utilisateurs de localiser et de visualiser les planches disponibles,
  facilitant ainsi le choix des emplacements de location.",
  icon_url:"",
  icon_url_alt:"Logo Mapbox",
  projet: surf
)

cloudinary_surf = Outil.create(
  nom: "Cloudinary",
  description: "Cloudinary est utilisé pour le stockage des images,
  assurant une gestion efficace des images et des performances optimales.",
  icon_url:"",
  icon_url_alt:"Logo Cloudinary",
  projet: surf
)

flatpickr_surf = Outil.create(
  nom: "Flatpickr",
  description: "Flatpickr est intégré pour faciliter la sélection de dates,
  améliorant l'expérience de l'utilisateur lors de l'entrée des informations.",
  icon_url:"",
  icon_url_alt:"Logo Flatpickr",
  projet: surf
)

bootstrap_surf = Outil.create(
  nom: "Bootstrap",
  description: "Le framework Bootstrap garantit un design réactif et esthétiquement plaisant,
  contribuant à une interface utilisateur moderne.",
  icon_url:"",
  icon_url_alt:"Logo Bootstrap",
  projet: surf
)

star_rating_surf = Outil.create(
  nom: "Star Rating",
  description: "L'intégration de Star Rating permet aux utilisateurs de noter les planches de surf,
  favorisant l'engagement communautaire et améliorant l'expérience de surf.",
  icon_url:"",
  icon_url_alt:"Logo Star Rating",
  projet: surf
)

tom_select_surf = Outil.create(
  nom: "Tom Select",
  description: "Tom Select est intégré pour faciliter la sélection des emplacements,
  améliorant l'expérience de l'utilisateur lors de l'entrée des informations.",
  icon_url:"",
  icon_url_alt:"Logo Tom Select",
  projet: surf
)

devise_surf = Outil.create(
  nom: "Devise",
  description: "L'utilisation de Devise simplifie l'implémentation de fonctionnalités liées à l'authentification et à la gestion des utilisateurs.",
  icon_url:"",
  icon_url_alt:"Logo Devise",
  projet: surf
)

github_surf = Outil.create(
  nom: "GitHub",
  description: "La plateforme GitHub est utilisée pour le suivi et la gestion du code source,
  favorisant la collaboration au sein de l'équipe de développement.",
  icon_url:"",
  icon_url_alt:"Logo GitHub",
  projet: surf
)

heroku_surf = Outil.create(
  nom: "Heroku",
  description: "Heroku est utilisé comme plateforme d'hébergement,
  assurant la disponibilité et la stabilité de Surf.ai.",
  icon_url:"",
  icon_url_alt:"Logo Heroku",
  projet: surf
)

trello_surf = Outil.create(
  nom: "Trello, Slack",
  description: "Trello est utilisé pour la gestion de projet,
  tandis que Slack facilite la communication au sein de l'équipe de développement.",
  icon_url:"",
  icon_url_alt:"Logo Trello",
  projet: surf
)

puts "Outils surf créés"

# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------

surviv = Projet.create(
  titre: "Surviv.ai",
  type_projet: "saas",
  description: "Logiciel de téléchargement et gestion de factures.
  Surviv.ai est une application de gestion des factures et des paiements.
  Le but du SaaS est d'éliminer les tâches répétitives et chronophages en automatisant le dépôt de factures et simplifiant la visualisation de leur statut.
  Surviv.ai permet aux utilisateurs ayant créé un compte, d'enregistrer les factures en téléchargeant le fichier pdf.
  En utilisant les outils API Mindee, le logiciel arrive à lire le pdf et à extraire de façon automatisée des détails cruciaux.
  Cette extraction est aussi possible à travers les pièces jointes aux e-mails grâce à Zapier.",
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

ruby_surviv = outil.create(
  nom: "Ruby On Rails",
  description: "Ruby on Rails est un framework libre écrit en Ruby.
  Il suit le motif d'architecture logicielle Modèle Vue Controleur.
  Le langage de programmation Ruby et le framework Rails sont au cœur du développement de Surviv.ai,
  assurant une base solide et une gestion efficace des données",
  icon_url:"",
  icon_url_alt:"Logo Ruby on Rails",
  projet: surviv
)

js_stimulus_surviv = outil.create(
  nom: "JavaScript et Stimulus",
  description: "L'utilisation de JavaScript, combinée au framework Stimulus,
  permet une interface utilisateur interactive et réactive,
  améliorant ainsi l'expérience utilisateur.",
  icon_url:"",
  icon_url_alt:"Logo JavaScript",
  projet: surviv
)

redis_surviv = outil.create(
  nom: "Redis",
  description: "Le système de stockage clé-valeur Redis est intégré pour des performances optimales,
  offrant une gestion rapide et efficace des données.",
  icon_url:"",
  icon_url_alt:"Logo Redis",
  projet: surviv
)

mindee_surviv = outil.create(
  nom: "Mindee API",
  description: "L'API Mindee est utilisée pour l'extraction automatisée des détails des factures à partir de documents PDF,
  optimisant ainsi le processus de gestion des factures.",
  icon_url:"",
  icon_url_alt:"Logo Mindee",
  projet: surviv
)

zapier_surviv = outil.create(
  nom: "Zapier",
  description: "L'intégration de Zapier facilite l'automatisation des tâches,
  améliorant l'efficacité opérationnelle de Surviv.ai.",
  icon_url:"",
  icon_url_alt:"Logo Zapier",
  projet: surviv
)

postgresql_surviv = outil.create(
  nom: "PostgreSQL",
  description: "Les bases de données SQL sont utilisées pour le stockage et la gestion structurée des données,
  assurant la stabilité et la fiabilité du système.",
  icon_url:"",
  icon_url_alt:"Logo PostgreSQL",
  projet: surviv
)

flatpickr_surviv = outil.create(
  nom: "Flatpickr",
  description: "Flatpickr est intégré pour faciliter la sélection de dates,
  améliorant l'expérience de l'utilisateur lors de l'entrée des informations.",
  icon_url:"",
  icon_url_alt:"Logo Flatpickr",
  projet: surviv
)

bootstrap_surviv = outil.create(
  nom: "Bootstrap",
  description: "Le framework Bootstrap garantit un design réactif et esthétiquement plaisant,
  contribuant à une interface utilisateur moderne.",
  icon_url:"",
  icon_url_alt:"Logo Bootstrap",
  projet: surviv
)

devise_surviv = outil.create(
  nom: "Devise",
  description: "L'utilisation de Devise simplifie l'implémentation de fonctionnalités liées à l'authentification et à la gestion des utilisateurs.",
  icon_url:"",
  icon_url_alt:"Logo Devise",
  projet: surviv
)

github_surviv = outil.create(
  nom: "GitHub",
  description: "La plateforme GitHub est utilisée pour le suivi et la gestion du code source,
  favorisant la collaboration au sein de l'équipe de développement.",
  icon_url:"",
  icon_url_alt:"Logo GitHub",
  projet: surviv
)

heroku_surviv = outil.create(
  nom: "Heroku",
  description: "Heroku est utilisé comme plateforme d'hébergement,
  assurant la disponibilité et la stabilité de Surviv.ai.",
  icon_url:"",
  icon_url_alt:"Logo Heroku",
  projet: surviv
)

trello_surviv = outil.create(
  nom: "Trello, Slack",
  description: "Trello est utilisé pour la gestion de projet,
  tandis que Slack facilite la communication au sein de l'équipe de développement.",
  icon_url:"",
  icon_url_alt:"Logo Trello",
  projet: surviv
)

puts "Outils surviv créés"

# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------
# ---------------------NEW PROJET -------------------------------


# t.string :nom
#       t.text :description
#       t.string :icone_url
#       t.string :icone_url_alt
#       t.references :projet, foreign_key: true



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
