# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Reset database
Projet.destroy_all
puts "Reset database"

# Create project
surf = Projet.create(
  titre: "Surf.ai",
  type_projet: "application web",
  description: "Plateforme de location de planches de surf entre particuliers.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1698925883/production/66xsp347pg4llarxvcikcys3depg.png",
  image_url_alt: "Capture ecran du projet Surf.ai",
  date_debut: "2023-08-21",
  date_fin: "2023-08-25",
  client: "Projet personnel",
  github_lien: "https://github.com/MaxOudin/surf-ai/blob/master/README.md",
  couleur: "#6AE897")

puts "Projet surf créé"


surviv = Projet.create(
  titre: "Surviv.ai",
  type_projet: "saas",
  description: "Logiciel de téléchargement et gestion de factures.
  Surviv.ai est une application de gestion des factures et des paiements.
  Le but du SaaS est d'éliminer les tâches répétitives et chronophages en automatisant le dépôt de factures et simplifiant la visualisation de leur statut.
  Surviv.ai permet aux utilisateurs ayant créé un compte, d'enregistrer les factures en la téléchargeant.
  En utilisant les outils API Mindee, le logiciel arrive à lire le pdf et à extraire de façon automatisée des détails cruciaux.
  Cette extraction est aussi possible à travers les pièces jointes aux e-mails grâce à Zapier.
  Surviv.ai accorde une importance particulière à une expérience utilisateur en simplifiant le dépôt de factures.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1696419032/Capture_d_e%CC%81cran_2023-10-03_a%CC%80_14.32.06_jwjcda.png",
  image_url_alt: "Capture ecran du projet Survivai, vue des factures en cartes",
  date_debut: "2023-09-04",
  date_fin: "2023-09-08",
  client: "Projet personnel",
  github_lien: "https://github.com/MaxOudin/-surviv-ai/blob/master/README.md",
  couleur: "#90CAFC")

puts "Projet surviv créé"

# Create outils
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
