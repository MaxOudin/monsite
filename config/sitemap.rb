# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://#{ENV['DOMAIN']}"

# The directory to write sitemaps to locally
SitemapGenerator::Sitemap.public_path = 'public/'

# Set this to a directory/path if you don't want to upload to the root
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Add default priority of 0.5 and changefreq of 'weekly' to all URLs
  # unless specified otherwise
  default_priority = 0.5
  default_changefreq = 'weekly'

  # Accueil - Priorité maximale
  add '/', changefreq: 'daily', priority: 1.0

  # Pages Projets
  add projets_path, changefreq: 'weekly', priority: 0.9
  Projet.find_each do |projet|
    add projet_path(projet),
        lastmod: projet.updated_at,
        changefreq: 'monthly',
        priority: 0.8,
        images: [{
          loc: projet.image_url,
          title: projet.titre
        }] if projet.image_url.present?
  end

  # Pages Articles
  add articles_path, changefreq: 'weekly', priority: 0.9
  Article.find_each do |article|
    add article_path(article),
        lastmod: article.updated_at,
        changefreq: 'monthly',
        priority: 0.8,
        images: [{
          loc: article.image_url,
          title: article.titre
        }] if article.image_url.present?
  end

  # Autres pages importantes
  add '/mentions-legales', changefreq: 'monthly', priority: 0.3
end
