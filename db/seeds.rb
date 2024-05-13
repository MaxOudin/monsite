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


# # Create user
# user = User.where(email: ENV['USER_EMAIL']).first_or_initialize
# user.update!(
#   password: ENV.fetch("USER_PASSWORD"),
#   password_confirmation: ENV.fetch("USER_PASSWORD")
# )
# puts "User Maxime créé"

# --------------------- NEW PROJET -------------------------------
# --------------------- SURF AI -------------------------------

surf = Projet.create(
  titre: "Surf Ai",
  type_projet: "application web",
  description: "Surf.Ai est une plateforme de location de planches de surf entre particuliers.
  Je peux à la fois proposer mes planches à la location et louer des planches de surf d'autres propriétaires.
  En tant qu'utilisateur, je peux donc créer une planche avec un prix par jour et lui ajouter plusieurs photos pour la proposer à la location.
  Depuis l'accueil, je peux voir les planches disponibles avec la moyenne des notes laissés par les précédents locataires et chacune géocalisée sur la carte.
  Il est possible de rechercher plus précisemment des planches de surf en fonction de leur type, pour trouver celle qui me correspond.
  Les locataires peuvent consulter les évaluations et avis des clients précédents, assurant des choix éclairés.
  Avant de confirmer la réservation la plateforme Surf.ai vous montre le récapitulatif de l'offre.
  Vous pourrez y retrouver les détails de votre choix pour vérifier notamment des dates spécifiques et le budget total.
  Surf.Ai offre à chaque utilisateur un espace présentant l'historique de réservations et de locations.
  Cela favorise l'engagement communautaire grâce aux évaluations et aux avis post-location, améliorant ainsi l'expérience des utilisateurs.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1698925883/production/66xsp347pg4llarxvcikcys3depg.png",
  image_url_alt: "Capture ecran du projet Surf.ai",
  date_debut: "2023-08-21",
  date_fin: "2023-08-25",
  client: "Projet sprint 1 semaine",
  github_lien: "https://github.com/MaxOudin/surf-ai/blob/master/README.md",
  couleur: "#6AE897"
  )

puts "Projet surf créé"


# --------------------- NEW PROJET -------------------------------
# --------------------- SURVIV AI -------------------------------

surviv = Projet.create(
  titre: "Surviv Ai",
  type_projet: "saas",
  description: "Surviv.Ai est un logiciel de téléchargement et gestion de factures.
  Le but du SaaS (Software As A Service) est d'éliminer les tâches répétitives et chronophages.
  Nous avons choisi d'automatiser le dépôt de factures et de simplifier la visualisation de leur statut.
  Surviv.Ai permet aux utilisateurs ayant créé un compte, de pouvoir enregistrer les factures en téléchargeant le fichier pdf.
  Notre technologie lit le pdf et extrait de façon automatisée les détails cruciaux pour l'enregistrer dans la base de données.
  Cette extraction est aussi possible à travers les pièces jointes aux e-mails.
  En effet, notre technologie est aussi capable de lire le pdf inclut en pièce jointe et d'extraire les informations.
  Je peux ensuite visualiser les factures enregistrées et leur statut sous différents aspects selon mon choix.
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

# --------------------- NEW PROJET -------------------------------
# --------------------- SHAZAM API -------------------------------

music = Projet.create(
  titre: 'Shazam API',
  type_projet: "application web",
  description: "Voici MaxMusic, outil de recherches de Music par mots clés.
  Ma mémoire me fait parfois défaut, et je connais approximativement le titre de la musique...
  Avec Maxmusic vous pouvez utiliser la barre de recherche pour retrouver vos chansons préférées à partir de quelques mots.
  J'ai pensé qu'il serait agréable de trouver directement la pochette de l'album pour avoir un visuel.
  Afin de s'assurer que le résultat convient à notre recherche vous aurez quelques informations supplémentaires.
  Mais surtout vous aurez la possibilité d'écouter la musique, sans avoir à naviguer sur d'autres onglets ou directement aller voir le clip sur Youtube.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1697205527/home_g3tvhj.png",
  image_url_alt: "Capture ecran du projet MaxMusic, outil de recherche de musiques via API Shazam",
  date_debut: "2023-09-24",
  date_fin: "2023-10-08",
  client: "Projet personnel",
  github_lien: 'https://github.com/MaxOudin/Maxmusic#readme',
  couleur: "#6AE2C6"
)

puts "Projets music créés"



# --------------------- OUTILS pour projet -------------------------------
# --------------------- OUTILS pour projet -------------------------------
# --------------------- OUTILS pour projet -------------------------------

ruby = Outil.create(
  nom: "Ruby",
  description: "Ruby est un langage de programmation populaire utilisé pour le développement d'applications web. Il est apprécié pour sa syntaxe élégante et sa simplicité."
)

rails = Outil.create(
  nom: "Rails",
  description: "Ruby on Rails est un framework web open-source écrit en Ruby. Il est utilisé pour développer des applications web robustes et évolutives."
)

js_stimulus = Outil.create(
  nom: "JavaScript et Stimulus",
  description: "JavaScript est un langage de programmation utilisé pour rendre les pages web interactives. Stimulus est un framework JavaScript léger et efficace pour ajouter des fonctionnalités interactives aux pages web."
)

flatpickr = Outil.create(
  nom: "Flatpickr",
  description: "Flatpickr est une bibliothèque JavaScript pour sélectionner des dates et des heures dans les formulaires web. Elle offre une interface utilisateur conviviale et réactive."
)

bootstrap = Outil.create(
  nom: "Bootstrap",
  description: "Bootstrap est un framework front-end open-source pour le développement web. Il fournit des composants prêts à l'emploi pour créer des interfaces utilisateur attrayantes et réactives."
)

devise = Outil.create(
  nom: "Devise",
  description: "Devise est une bibliothèque Ruby on Rails pour l'authentification des utilisateurs. Elle fournit des fonctionnalités telles que l'inscription, la connexion et la récupération de mot de passe."
)

github = Outil.create(
  nom: "GitHub",
  description: "GitHub est une plateforme de développement logiciel basée sur Git. Elle offre des fonctionnalités de suivi des problèmes, de gestion de versions et de collaboration pour les projets de développement logiciel."
)

heroku = Outil.create(
  nom: "Heroku",
  description: "Heroku est une plateforme cloud qui permet le déploiement et l'hébergement d'applications web. Elle prend en charge plusieurs langages de programmation et offre une gestion facile des ressources d'application."
)

trello = Outil.create(
  nom: "Trello, Slack",
  description: "Trello est un outil de gestion de projet en ligne qui utilise des tableaux Kanban pour organiser les tâches. Slack est une plateforme de communication d'équipe qui facilite la collaboration et la communication en temps réel."
)

redis = Outil.create(
  nom: "Redis",
  description: "Redis est une base de données de type clé-valeur open-source. Elle est utilisée pour le stockage en mémoire cache, la gestion de sessions et d'autres cas d'utilisation nécessitant une haute performance."
)

mindee = Outil.create(
  nom: "Mindee API",
  description: "L'API Mindee est utilisée pour l'extraction de données à partir de documents PDF. Elle offre des fonctionnalités avancées pour extraire des informations telles que les coordonnées, les montants et les dates à partir de factures et de reçus."
)

zapier = Outil.create(
  nom: "Zapier",
  description: "Zapier est une plateforme d'automatisation des tâches qui permet de connecter des applications web et de créer des flux de travail automatisés. Elle offre des intégrations avec des centaines d'applications populaires."
)

postgresql = Outil.create(
  nom: "PostgreSQL",
  description: "PostgreSQL est un système de gestion de base de données relationnelle open-source. Il offre des fonctionnalités avancées telles que la prise en charge des transactions ACID, les index avancés et les fonctions stockées."
)

mapbox = Outil.create(
  nom: "Mapbox",
  description: "Mapbox est une plateforme de cartographie en ligne qui offre des services de cartographie personnalisés et des outils de visualisation de données géospatiales. Elle est utilisée pour créer des cartes interactives et personnalisées dans les applications web."
)

cloudinary = Outil.create(
  nom: "Cloudinary",
  description: "Cloudinary est un service de gestion des ressources multimédias dans le cloud. Il offre des fonctionnalités telles que le stockage d'images, la manipulation d'images et la diffusion de contenu multimédia."
)

star_rating = Outil.create(
  nom: "Star Rating",
  description: "Star Rating est une bibliothèque JavaScript pour la notation des éléments dans les applications web. Elle permet aux utilisateurs de donner des évaluations en étoiles et de visualiser les scores moyens."
)

tom_select = Outil.create(
  nom: "Tom Select",
  description: "Tom Select est une bibliothèque JavaScript pour les champs de sélection avancés dans les formulaires web. Elle offre une interface utilisateur améliorée pour sélectionner des options à partir de listes déroulantes et de champs de recherche."
)

shazam_api = Outil.create(
  nom: "Shazam API",
  description: "L'API Shazam est utilisée pour la recherche de musique en ligne. Elle permet aux utilisateurs de reconnaître des chansons à partir de courts extraits audio et de trouver des informations sur les artistes et les titres."
)

postman = Outil.create(
  nom: "Postman & API REST",
  description: "Postman est un client API qui permet de tester, de développer et de documenter les API REST. Il offre des fonctionnalités avancées telles que la gestion des environnements, les tests automatisés et la génération de documentation."
)

puts "Outils créés"


surf = Projet.find_by(titre: "Surf Ai")
surviv = Projet.find_by(titre: "Surviv Ai")
music = Projet.find_by(titre: "Shazam API")

# -------- ATTRIBUTION DES OUTILS ---------
# -------- ATTRIBUTION DES OUTILS ---------
# -------- ATTRIBUTION DES OUTILS ---------

# -------- Ruby ---------
surf.outils << ruby
surviv.outils << ruby
music.outils << ruby

# -------- Ruby ---------
surf.outils << rails
surviv.outils << rails
music.outils << rails

# -------- JS Stimulus ---------
surf.outils << js_stimulus
surviv.outils << js_stimulus
music.outils << js_stimulus

# -------- Flatpickr ---------
surf.outils << flatpickr
surviv.outils << flatpickr

# -------- Bootstrap ---------
surf.outils << bootstrap
surviv.outils << bootstrap
music.outils << bootstrap

# -------- Devise ---------
surf.outils << devise
surviv.outils << devise

# -------- GitHub ---------
surf.outils << github
surviv.outils << github
music.outils << github

# -------- Heroku ---------
surf.outils << heroku
surviv.outils << heroku

# -------- Trello ---------
surf.outils << trello
surviv.outils << trello

# -------- Redis ---------
surviv.outils << redis

# -------- Mindee ---------
surviv.outils << mindee

# -------- Zapier ---------
surviv.outils << zapier

# -------- PostgreSQL ---------
surviv.outils << postgresql

# -------- Mapbox ---------
surf.outils << mapbox

# -------- Cloudinary ---------
surf.outils << cloudinary

# -------- Star rating ---------
surf.outils << star_rating

# -------- Tom Select ---------
surf.outils << tom_select

# -------- Shazam API ---------
music.outils << shazam_api

# -------- Postman ---------
music.outils << postman

surf.save
surviv.save
music.save

puts "Outils attribués aux projets"
