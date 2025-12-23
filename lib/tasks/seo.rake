namespace :seo do
  desc "Vérifier la configuration SEO du site"
  task check: :environment do
    puts "\n🔍 Vérification de la configuration SEO...\n\n"

    # Vérifier les variables d'environnement
    puts "1. Variables d'environnement:"
    if ENV['DOMAIN'].present?
      puts "   ✅ DOMAIN configuré: #{ENV['DOMAIN']}"
    else
      puts "   ❌ DOMAIN non configuré"
    end

    if ENV['REDIS_URL'].present?
      puts "   ✅ REDIS_URL configuré"
    else
      puts "   ⚠️  REDIS_URL non configuré (optionnel en développement)"
    end

    # Vérifier les meta tags par défaut
    puts "\n2. Meta tags par défaut:"
    begin
      meta = YAML.load_file(Rails.root.join("config/meta.yml"))
      puts "   ✅ meta_title: #{meta['meta_title']}"
      puts "   ✅ meta_description: #{meta['meta_description']}"
      puts "   ✅ meta_keywords: #{meta['meta_keywords']}"
      puts "   ✅ meta_image: #{meta['meta_image']}"
    rescue => e
      puts "   ❌ Erreur lors de la lecture de config/meta.yml: #{e.message}"
    end

    # Vérifier le sitemap
    puts "\n3. Configuration sitemap:"
    if File.exist?(Rails.root.join("config/sitemap.rb"))
      puts "   ✅ config/sitemap.rb présent"
    else
      puts "   ❌ config/sitemap.rb manquant"
    end

    # Vérifier robots.txt
    puts "\n4. Fichier robots.txt:"
    if File.exist?(Rails.root.join("public/robots.txt"))
      puts "   ✅ public/robots.txt présent"
      content = File.read(Rails.root.join("public/robots.txt"))
      if content.include?("Sitemap:")
        puts "   ✅ Sitemap référencé dans robots.txt"
      else
        puts "   ⚠️  Sitemap non référencé dans robots.txt"
      end
    else
      puts "   ❌ public/robots.txt manquant"
    end

    # Vérifier les helpers
    puts "\n5. Helpers SEO:"
    helpers = [
      "app/helpers/meta_tags_helper.rb",
      "app/helpers/structured_data_helper.rb",
      "app/helpers/performance_helper.rb"
    ]
    
    helpers.each do |helper|
      if File.exist?(Rails.root.join(helper))
        puts "   ✅ #{helper}"
      else
        puts "   ❌ #{helper} manquant"
      end
    end

    # Statistiques de contenu
    puts "\n6. Statistiques de contenu:"
    puts "   📝 Articles: #{Article.count}"
    puts "   🚀 Projets: #{Projet.count}"
    puts "   🛠️  Outils: #{Outil.count}"

    # Vérifier les slugs
    puts "\n7. URLs optimisées (FriendlyId):"
    projets_sans_slug = Projet.where(slug: nil).count
    articles_sans_slug = Article.where(slug: nil).count
    
    if projets_sans_slug.zero? && articles_sans_slug.zero?
      puts "   ✅ Tous les projets et articles ont un slug"
    else
      puts "   ⚠️  #{projets_sans_slug} projets sans slug" if projets_sans_slug > 0
      puts "   ⚠️  #{articles_sans_slug} articles sans slug" if articles_sans_slug > 0
    end

    # Vérifier les images
    puts "\n8. Vérification des images:"
    projets_sans_image = Projet.where("image_url IS NULL OR image_url = ''").count
    articles_sans_image = Article.where("image_url IS NULL OR image_url = ''").count
    
    if projets_sans_image.zero? && articles_sans_image.zero?
      puts "   ✅ Tous les projets et articles ont une image"
    else
      puts "   ⚠️  #{projets_sans_image} projets sans image" if projets_sans_image > 0
      puts "   ⚠️  #{articles_sans_image} articles sans image" if articles_sans_image > 0
    end

    puts "\n✨ Vérification terminée!\n\n"
  end

  desc "Générer le sitemap et afficher des statistiques"
  task generate_sitemap: :environment do
    puts "\n📊 Génération du sitemap...\n"
    
    begin
      Rake::Task["sitemap:refresh"].invoke
      puts "\n✅ Sitemap généré avec succès!"
      
      if File.exist?(Rails.root.join("public/sitemaps/sitemap.xml.gz"))
        puts "   📍 Sitemap disponible à: https://#{ENV['DOMAIN']}/sitemaps/sitemap.xml.gz"
      end
      
      puts "\n📈 Contenu inclus dans le sitemap:"
      puts "   - Page d'accueil (priorité: 1.0)"
      puts "   - Page Projets (priorité: 0.9)"
      puts "   - #{Projet.count} projets (priorité: 0.8)"
      puts "   - Page Articles (priorité: 0.9)"
      puts "   - #{Article.count} articles (priorité: 0.7)"
      puts "   - Page Services (priorité: 0.8)"
      puts "   - Mentions légales (priorité: 0.2)"
      
      total_urls = 4 + Projet.count + Article.count
      puts "\n   📝 Total: #{total_urls} URLs dans le sitemap"
      
    rescue => e
      puts "\n❌ Erreur lors de la génération: #{e.message}"
    end
    
    puts "\n"
  end

  desc "Valider les données structurées"
  task validate_structured_data: :environment do
    puts "\n🔍 Validation des données structurées...\n"
    
    puts "Pour valider vos données structurées:"
    puts "1. Démarrez votre serveur: rails s"
    puts "2. Visitez ces URLs dans l'outil Google:"
    puts "   https://search.google.com/test/rich-results\n\n"
    
    if ENV['DOMAIN'].present?
      puts "URLs à tester:"
      puts "   - Page d'accueil: https://#{ENV['DOMAIN']}"
      
      if Projet.exists?
        projet = Projet.first
        puts "   - Exemple projet: https://#{ENV['DOMAIN']}/projets/#{projet.slug}"
      end
      
      if Article.exists?
        article = Article.first
        puts "   - Exemple article: https://#{ENV['DOMAIN']}/articles/#{article.slug}"
      end
    else
      puts "⚠️  DOMAIN non configuré, impossible de générer les URLs de test"
    end
    
    puts "\n"
  end

  desc "Rapport SEO complet"
  task report: :environment do
    puts "\n" + "="*60
    puts "📊 RAPPORT SEO COMPLET".center(60)
    puts "="*60 + "\n"

    # Date du rapport
    puts "📅 Date: #{Time.current.strftime('%d/%m/%Y à %H:%M')}\n\n"

    # Contenu
    puts "📝 CONTENU"
    puts "-" * 60
    puts "Articles publiés:        #{Article.count}"
    puts "Projets publiés:         #{Projet.count}"
    puts "Outils référencés:       #{Outil.count}"
    
    # Articles récents
    recent_articles = Article.order(created_at: :desc).limit(3)
    if recent_articles.any?
      puts "\nDerniers articles:"
      recent_articles.each do |article|
        puts "  • #{article.titre} (#{article.created_at.strftime('%d/%m/%Y')})"
      end
    end

    # Projets récents
    recent_projets = Projet.order(created_at: :desc).limit(3)
    if recent_projets.any?
      puts "\nDerniers projets:"
      recent_projets.each do |projet|
        puts "  • #{projet.titre} (#{projet.created_at.strftime('%d/%m/%Y')})"
      end
    end

    # Qualité du contenu
    puts "\n\n🎯 QUALITÉ DU CONTENU"
    puts "-" * 60
    
    # Vérifier les descriptions courtes
    projets_description_courte = Projet.where("LENGTH(description) < 200").count
    articles_content_court = Article.joins(:rich_text_content)
                                    .where("LENGTH(action_text_rich_texts.body) < 500").count
    
    puts "Projets avec description < 200 caractères: #{projets_description_courte}"
    puts "Articles avec contenu < 500 caractères:    #{articles_content_court}"
    
    if projets_description_courte > 0 || articles_content_court > 0
      puts "\n⚠️  Recommandation: Enrichir les contenus trop courts"
    else
      puts "\n✅ Tous les contenus ont une longueur appropriée"
    end

    # URLs et Slugs
    puts "\n\n🔗 URLS & SLUGS"
    puts "-" * 60
    projets_avec_slug = Projet.where.not(slug: nil).count
    articles_avec_slug = Article.where.not(slug: nil).count
    puts "Projets avec slug:  #{projets_avec_slug}/#{Projet.count}"
    puts "Articles avec slug: #{articles_avec_slug}/#{Article.count}"

    # Images
    puts "\n\n🖼️  IMAGES"
    puts "-" * 60
    projets_avec_image = Projet.where.not(image_url: [nil, '']).count
    projets_avec_alt = Projet.where.not(image_url_alt: [nil, '']).count
    articles_avec_image = Article.where.not(image_url: [nil, '']).count
    articles_avec_alt = Article.where.not(image_alt: [nil, '']).count
    
    puts "Projets avec image:     #{projets_avec_image}/#{Projet.count}"
    puts "Projets avec alt text:  #{projets_avec_alt}/#{Projet.count}"
    puts "Articles avec image:    #{articles_avec_image}/#{Article.count}"
    puts "Articles avec alt text: #{articles_avec_alt}/#{Article.count}"

    # Configuration technique
    puts "\n\n⚙️  CONFIGURATION TECHNIQUE"
    puts "-" * 60
    puts "DOMAIN:        #{ENV['DOMAIN'].present? ? "✅ #{ENV['DOMAIN']}" : '❌ Non configuré'}"
    puts "REDIS_URL:     #{ENV['REDIS_URL'].present? ? '✅ Configuré' : '⚠️  Non configuré'}"
    puts "Sitemap:       #{File.exist?(Rails.root.join('public/sitemaps/sitemap.xml.gz')) ? '✅ Généré' : '❌ Non généré'}"
    puts "Robots.txt:    #{File.exist?(Rails.root.join('public/robots.txt')) ? '✅ Présent' : '❌ Absent'}"

    # Recommandations
    puts "\n\n💡 RECOMMANDATIONS"
    puts "-" * 60
    
    recommendations = []
    
    # Contenu
    if Article.count < 5
      recommendations << "Créer plus d'articles (actuellement: #{Article.count}, objectif: 10+)"
    end
    
    if Projet.count < 5
      recommendations << "Ajouter plus de projets (actuellement: #{Projet.count}, objectif: 10+)"
    end
    
    # Qualité
    if projets_description_courte > 0
      recommendations << "Enrichir #{projets_description_courte} descriptions de projets (min 200 caractères)"
    end
    
    # Images
    if projets_avec_alt < Projet.count
      recommendations << "Ajouter des alt text manquants (#{Projet.count - projets_avec_alt} projets)"
    end
    
    if articles_avec_alt < Article.count
      recommendations << "Ajouter des alt text manquants (#{Article.count - articles_avec_alt} articles)"
    end
    
    # Sitemap
    unless File.exist?(Rails.root.join('public/sitemaps/sitemap.xml.gz'))
      recommendations << "Générer le sitemap: rake sitemap:refresh"
    end
    
    if recommendations.any?
      recommendations.each_with_index do |rec, index|
        puts "#{index + 1}. #{rec}"
      end
    else
      puts "✅ Aucune action urgente requise!"
      puts "💪 Continuez à publier du contenu régulièrement."
    end

    # Prochaines étapes
    puts "\n\n🎯 PROCHAINES ÉTAPES SUGGÉRÉES"
    puts "-" * 60
    puts "1. Publier 2 nouveaux articles ce mois"
    puts "2. Mettre à jour les projets avec plus de détails"
    puts "3. Vérifier Google Search Console pour les erreurs"
    puts "4. Analyser les performances avec Google Analytics"
    puts "5. Optimiser les images (compression, format WebP)"

    puts "\n" + "="*60
    puts "Rapport généré avec succès!".center(60)
    puts "="*60 + "\n\n"
  end

  desc "Vérifier les meta tags de toutes les pages importantes"
  task check_meta_tags: :environment do
    puts "\n🏷️  Vérification des meta tags...\n\n"

    # Meta par défaut
    puts "Meta tags par défaut:"
    meta = YAML.load_file(Rails.root.join("config/meta.yml"))
    puts "  Title:       #{meta['meta_title']} (#{meta['meta_title'].length} caractères)"
    puts "  Description: #{meta['meta_description'][0..60]}... (#{meta['meta_description'].length} caractères)"
    puts "  Keywords:    #{meta['meta_keywords']}"
    
    # Recommandations longueur
    if meta['meta_title'].length > 60
      puts "  ⚠️  Title trop long (max 60 caractères recommandé)"
    end
    
    if meta['meta_description'].length < 120 || meta['meta_description'].length > 160
      puts "  ⚠️  Description devrait faire entre 120 et 160 caractères"
    end

    # Vérifier quelques projets
    puts "\n\nProjets (échantillon):"
    Projet.limit(3).each do |projet|
      title = "#{projet.titre} | #{meta['meta_product_name']}"
      desc = projet.description.truncate(160)
      
      puts "\n  #{projet.titre}:"
      puts "    Title: #{title} (#{title.length} caractères)"
      puts "    Desc:  #{desc[0..60]}... (#{desc.length} caractères)"
      puts "    Image: #{projet.image_url.present? ? '✅' : '❌'}"
      puts "    Alt:   #{projet.image_url_alt.present? ? '✅' : '❌'}"
    end

    # Vérifier quelques articles
    puts "\n\nArticles (échantillon):"
    Article.limit(3).each do |article|
      title = "#{article.titre} | #{meta['meta_product_name']}"
      desc = article.content.to_plain_text.truncate(160) rescue article.titre
      
      puts "\n  #{article.titre}:"
      puts "    Title: #{title} (#{title.length} caractères)"
      puts "    Desc:  #{desc[0..60]}... (#{desc.length} caractères)"
      puts "    Image: #{article.image_url.present? ? '✅' : '❌'}"
      puts "    Alt:   #{article.image_alt.present? ? '✅' : '❌'}"
    end

    puts "\n"
  end
end

