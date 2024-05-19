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

puts "Projets music créé"


arko = Projet.create(
  titre: 'CMS personnalisé',
  type_projet: "saas",
  description: "Arko CMS est un système de gestion de contenu (CMS) qui permet de construire l'API pour un site web.
  Il permet aux utilisateurs de créer, modifier et publier du contenu en ligne sans avoir besoin de compétences techniques.
  En effet, il est possible de créer des projets ou organisations, d'y attribuer du contenu, des images, des documents, des vidéos et de les publier sur le site web.
  Dans le cadre du développement du CMS Arko et du site Partnerships4SustainableCities, des améliorations significatives ont été apportées entre janvier et avril 2024.
  Ces améliorations se concentrent sur la gestion des données et l'expérience utilisateur pour une navigation plus fluide et intuitive.
  Parmi les principales modifications apportées, on retrouve une organisation thématique des données par ordre alphabétique, l'implémentation d'une fonction de recherche par attribut principal, et la possibilité de prévisualiser, télécharger et supprimer divers types de fichiers.
  De plus, des ajustements ont été faits pour améliorer l'expérience utilisateur, notamment en corrigeant le processus de réinitialisation de mot de passe et en traduisant les informations affichées en plusieurs langues.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1715628235/Capture_d_e%CC%81cran_2024-05-13_a%CC%80_21.18.43_mdlpxr.png",
  image_url_alt: "Capture ecran du projet Arko CMS",
  date_debut: "2024-02-01",
  date_fin: "2024-04-30",
  client: "Arko Consulting",
  projet_lien: "https://api.partnerships4sustainablecities.eu/management",
  github_lien: "",
  couleur: "#0C6DFD"
)

cities = Projet.create(
  titre: 'Partnerships4SustainableCities',
  type_projet: "application web",
  description: "Partnerships4SustainableCities est une plateforme en ligne qui vise à promouvoir les partenariats pour le développement durable dans les villes.
  Elle offre un espace de collaboration pour les acteurs locaux, régionaux et internationaux engagés dans la mise en œuvre des objectifs de développement durable (ODD) des Nations Unies.
  La plateforme permet aux utilisateurs de partager des informations, des ressources et des bonnes pratiques, de collaborer sur des projets communs et de suivre les progrès réalisés vers les ODD.
  Elle offre également des fonctionnalités de suivi des objectifs, de gestion des partenariats et de communication entre les membres de la communauté.
  La plateforme Partnerships4SustainableCities est un outil essentiel pour renforcer la coopération et l'engagement en faveur du développement durable au niveau local et mondial.",
  image_url: "https://res.cloudinary.com/dyleaesxc/image/upload/v1715672170/Capture_d_e%CC%81cran_2024-05-13_a%CC%80_21.19.33_jw5zax.png",
  image_url_alt: "Capture ecran du site Partnerships4SustainableCities",
  date_debut: "2024-02-01",
  date_fin: "2024-04-30",
  client: "Arko Consulting",
  projet_lien: "https://partnerships4sustainablecities.eu/",
  github_lien: "",
  couleur: "#7AB829"
)


puts "Projet Arko créé"


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

javascript = Outil.create(
  nom: "JavaScript",
  description: "JavaScript est un langage de programmation utilisé pour rendre les pages web interactives. Il offre des fonctionnalités avancées pour la manipulation du DOM, les animations et les interactions utilisateur."
)

nuxt3 = Outil.create(
  nom: "Nuxt 3",
  description: "Nuxt 3 est un framework JavaScript pour le développement web. Il offre des fonctionnalités avancées telles que le rendu côté serveur, la génération de pages statiques et la gestion des données."
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

gitlab = Outil.create(
  nom: "GitLab",
  description: "GitLab est une plateforme de développement logiciel basée sur Git. Elle offre des fonctionnalités de suivi des problèmes, de gestion de versions et de collaboration pour les projets de développement logiciel."
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

aws = Outil.create(
  nom: "AWS S3",
  description: "Amazon S3 (Simple Storage Service) est un service de stockage en ligne d'Amazon Web Services. Il offre un stockage sécurisé, évolutif et fiable pour les données, les images et les vidéos dans le cloud."
)

turbo = Outil.create(
  nom: "Turbo Hotwire",
  description: "Turbo Hotwire est un framework JavaScript pour le développement web. Il offre des fonctionnalités avancées telles que le rendu côté serveur, la mise en cache des fragments de page et la mise à jour en temps réel des données."
)

typescript = Outil.create(
  nom: "TypeScript",
  description: "TypeScript est un langage de programmation basé sur JavaScript. Il offre des fonctionnalités avancées telles que le typage statique, les interfaces et les classes pour améliorer la qualité du code."
)

vuejs = Outil.create(
  nom: "Vue.js",
  description: "Vue.js est un framework JavaScript pour le développement web. Il offre des fonctionnalités avancées telles que le rendu côté client, la gestion des composants et la réactivité des données."
)

openlayers = Outil.create(
  nom: "OpenLayers",
  description: "OpenLayers est une bibliothèque JavaScript pour la cartographie en ligne. Elle offre des fonctionnalités avancées pour la visualisation de données géospatiales, la création de cartes interactives et la gestion des couches de carte."
)

vercel = Outil.create(
  nom: "Vercel",
  description: "Vercel est une plateforme cloud pour le déploiement et l'hébergement d'applications web. Elle offre des fonctionnalités avancées telles que le déploiement automatique, la gestion des environnements et la surveillance des performances."
)


puts "Outils créés"


surf = Projet.find_by(titre: "Surf Ai")
surviv = Projet.find_by(titre: "Surviv Ai")
music = Projet.find_by(titre: "Shazam API")
arko = Projet.find_by(titre: "CMS personnalisé")
cities = Projet.find_by(titre: "Partnerships4SustainableCities")

# -------- ATTRIBUTION DES OUTILS ---------
# -------- ATTRIBUTION DES OUTILS ---------
# -------- ATTRIBUTION DES OUTILS ---------

# -------- JavaScript ---------
cities.outils << javascript

# -------- TypeScript ---------
cities.outils << typescript

# -------- Nuxt 3 ---------
cities.outils << nuxt3

# -------- Vue.js ---------
cities.outils << vuejs

# -------- OpenLayers ---------
cities.outils << openlayers

# -------- Vercel ---------
cities.outils << vercel

# -------- Ruby ---------
surf.outils << ruby
surviv.outils << ruby
music.outils << ruby
arko.outils << ruby

# -------- Rails ---------
surf.outils << rails
surviv.outils << rails
music.outils << rails
arko.outils << rails

# -------- JS Stimulus ---------
surf.outils << js_stimulus
surviv.outils << js_stimulus
music.outils << js_stimulus
arko.outils << js_stimulus

# -------- Flatpickr ---------
surf.outils << flatpickr
surviv.outils << flatpickr

# -------- Bootstrap ---------
surf.outils << bootstrap
surviv.outils << bootstrap
music.outils << bootstrap
arko.outils << bootstrap

# -------- Devise ---------
surf.outils << devise
surviv.outils << devise
arko.outils << devise

# -------- GitHub ---------
surf.outils << github
surviv.outils << github
music.outils << github

# -------- GitLab ---------
arko.outils << gitlab
cities.outils << gitlab

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
arko.outils << postgresql

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
arko.outils << postman
cities.outils << postman

# -------- AWS S3 ---------
arko.outils << aws

# -------- Turbo Hotwire ---------
arko.outils << turbo


puts "Outils attribués aux projets"

surf.save
surviv.save
music.save
arko.save

puts "Projets sauvegardés avec outils attribués"
