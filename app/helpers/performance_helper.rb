module PerformanceHelper
  # Génère un tag img optimisé avec lazy loading et dimensions
  def optimized_image_tag(source, alt_text, options = {})
    default_options = {
      loading: 'lazy',
      width: options[:width] || 1200,
      height: options[:height] || 800,
      alt: alt_text,
      class: options[:class]
    }
    
    image_tag(source, default_options.merge(options))
  end

  # Génère un srcset pour les images responsive
  def responsive_image_tag(source, alt_text, options = {})
    srcset = [
      "#{source}?w=320 320w",
      "#{source}?w=640 640w",
      "#{source}?w=1024 1024w",
      "#{source}?w=1200 1200w"
    ].join(", ")

    default_options = {
      loading: 'lazy',
      srcset: srcset,
      sizes: options[:sizes] || "(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 1200px",
      alt: alt_text,
      class: options[:class]
    }
    
    image_tag(source, default_options.merge(options))
  end

  # Précharge les ressources critiques
  def preload_critical_assets
    safe_join([
      tag.link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      tag.link(rel: 'preconnect', href: 'https://fonts.gstatic.com', crossorigin: true),
      tag.link(rel: 'dns-prefetch', href: 'https://tally.so')
    ])
  end
end

