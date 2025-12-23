class SitemapsController < ApplicationController
  # Le sitemap est accessible publiquement, pas besoin d'authentification

  def show
    sitemap_gz_path = Rails.root.join('public', 'sitemaps', 'sitemap.xml.gz')
    
    if File.exist?(sitemap_gz_path)
      # Pour un sitemap.xml.gz, on sert le fichier gzip avec les headers appropriés
      # Type XML car c'est du XML compressé, avec Content-Encoding: gzip
      # Lire le fichier binaire (déjà compressé)
      data = File.binread(sitemap_gz_path)
      
      # Définir les headers appropriés pour un fichier XML gzippé
      response.headers['Content-Type'] = 'application/xml; charset=utf-8'
      response.headers['Content-Encoding'] = 'gzip'
      response.headers['Content-Length'] = data.bytesize.to_s
      response.headers['Cache-Control'] = 'public, max-age=3600'
      
      # Envoyer les données
      send_data(data, disposition: 'inline')
    else
      head :not_found
    end
  end
end

