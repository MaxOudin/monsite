module StructuredDataHelper
  # Schema Organization pour la page d'accueil/entreprise
  def organization_structured_data
    {
      "@context": "https://schema.org",
      "@type": "ProfessionalService",
      "name": "Maxime Oudin - Développeur Web Indépendant",
      "description": DEFAULT_META['meta_description'],
      "url": "https://#{ENV['DOMAIN']}",
      "logo": image_url("yellow_logo.svg"),
      "image": image_url("yellow_logo.svg"),
      "telephone": "", # À compléter si souhaité
      "email": "", # À compléter si souhaité
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "Bordeaux",
        "addressRegion": "Nouvelle-Aquitaine",
        "postalCode": "33000",
        "addressCountry": "FR"
      },
      "geo": {
        "@type": "GeoCoordinates",
        "latitude": 44.837789,
        "longitude": -0.57918
      },
      "areaServed": {
        "@type": "GeoCircle",
        "geoMidpoint": {
          "@type": "GeoCoordinates",
          "latitude": 44.837789,
          "longitude": -0.57918
        },
        "geoRadius": "50000"
      },
      "priceRange": "$$",
      "sameAs": [
        DEFAULT_META['linkedin_url']
      ].compact
    }.to_json.html_safe
  end

  # Schema Website pour la page d'accueil
  def website_structured_data
    {
      "@context": "https://schema.org",
      "@type": "WebSite",
      "name": DEFAULT_META['meta_product_name'],
      "description": DEFAULT_META['meta_description'],
      "url": "https://#{ENV['DOMAIN']}",
      "potentialAction": {
        "@type": "SearchAction",
        "target": "https://#{ENV['DOMAIN']}/search?q={search_term_string}",
        "query-input": "required name=search_term_string"
      },
      "inLanguage": "fr-FR",
      "author": {
        "@type": "Person",
        "name": "Maxime Oudin"
      }
    }.to_json.html_safe
  end

  def person_schema
    {
      "@context": "https://schema.org",
      "@type": "Person",
      "name": "Maxime Oudin",
      "jobTitle": "Développeur concepteur web indépendant",
      "url": "https://#{ENV['DOMAIN']}",
      "image": image_url("yellow_logo.svg"),
      "address": {
        "@type": "PostalAddress",
        "addressLocality": "Bordeaux",
        "addressCountry": "FR"
      },
      "worksFor": {
        "@type": "Organization",
        "name": "Maxime Oudin - Développeur Web Indépendant"
      },
      "knowsAbout": [
        "Ruby on Rails",
        "JavaScript",
        "Développement Web",
        "E-commerce",
        "Applications Web"
      ]
    }.to_json.html_safe
  end

  def projet_schema(projet)
    {
      "@context": "https://schema.org",
      "@type": "CreativeWork",
      "name": projet.titre,
      "description": projet.description,
      "image": projet.image_url,
      "dateCreated": projet.date_debut&.iso8601,
      "dateModified": projet.updated_at.iso8601,
      "author": {
        "@type": "Person",
        "name": "Maxime Oudin"
      },
      "url": projet_url(projet)
    }.to_json.html_safe
  end

  def article_schema(article)
    {
      "@context": "https://schema.org",
      "@type": "Article",
      "headline": article.titre,
      "description": article.content.to_plain_text.truncate(160),
      "image": article.image_url,
      "datePublished": article.created_at.iso8601,
      "dateModified": article.updated_at.iso8601,
      "author": {
        "@type": "Person",
        "name": "Maxime Oudin"
      },
      "publisher": {
        "@type": "Organization",
        "name": "Maxime Oudin",
        "logo": {
          "@type": "ImageObject",
          "url": image_url("yellow_logo.svg")
        }
      },
      "mainEntityOfPage": {
        "@type": "WebPage",
        "@id": article_url(article)
      }
    }.to_json.html_safe
  end

  def breadcrumb_schema(items)
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": items.each_with_index.map do |item, index|
        {
          "@type": "ListItem",
          "position": index + 1,
          "name": item[:name],
          "item": item[:url]
        }
      end
    }.to_json.html_safe
  end
end

