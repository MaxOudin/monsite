class SitemapsController < ApplicationController
  # Le sitemap est accessible publiquement, pas besoin d'authentification

  def show
    sitemap_path = Rails.root.join('public', 'sitemaps', 'sitemap.xml.gz')
    
    if File.exist?(sitemap_path)
      # Servir le fichier avec les bons headers pour un sitemap gzippé
      send_file(
        sitemap_path,
        type: 'application/xml',
        disposition: 'inline',
        content_encoding: 'gzip',
        # Headers de cache pour optimiser les performances (1 heure)
        cache_control: 'public, max-age=3600'
      )
    else
      head :not_found
    end
  end
end

