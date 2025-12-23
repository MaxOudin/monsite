# app/helpers/breadcrumbs_helper.rb
module BreadcrumbsHelper
  # Génère automatiquement les breadcrumbs basés sur les conventions Rails
  #
  # @param custom_crumbs [Array<Hash>] Breadcrumbs personnalisés optionnels
  #   Format: [{ name: 'Nom', path: chemin_path }]
  # @return [Array<Hash>] Liste des breadcrumbs
  def breadcrumbs(custom_crumbs: nil)
    return custom_crumbs if custom_crumbs.present?

    crumbs = [home_crumb]

    case controller_name
    when 'projets'
      crumbs += projet_breadcrumbs if action_name == 'show'
    when 'articles'
      crumbs += article_breadcrumbs if action_name == 'show'
    end
    crumbs
  end

  # Affiche le fil d'ariane
  # @param custom_crumbs [Array<Hash>] Breadcrumbs personnalisés optionnels
  def render_breadcrumbs(custom_crumbs: nil)
    render partial: 'shared/breadcrumbs', locals: { crumbs: breadcrumbs(custom_crumbs: custom_crumbs) }
  end

  private

  def home_crumb
    { name: "Accueil", path: root_path, is_home: true }
  end

  # Génère le JSON-LD structured data pour le SEO
  # @param crumbs [Array<Hash>] Liste des breadcrumbs
  # @param current_url [String] URL complète de la page actuelle
  # @return [String] JSON-LD formaté et sécurisé
  def breadcrumbs_structured_data(crumbs, current_url)
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": crumbs.each_with_index.map do |crumb, index|
        {
          "@type": "ListItem",
          "position": index + 1,
          "name": crumb[:name],
          "item": crumb[:path].present? ? "#{request.base_url}#{crumb[:path]}" : current_url
        }
      end
    }.to_json.gsub('</', '<\/').html_safe
  end

  # Génère le label mobile pour le breadcrumb parent
  # @param parent [Hash] Le breadcrumb parent
  # @return [String] Nom du breadcrumb parent
  def breadcrumb_mobile_label(parent)
    parent[:name]
  end

  def projet_breadcrumbs
    return [] unless @projet

    [
      { name: "Projets", path: projets_path },
      { name: @projet.titre, path: nil }
    ]   
  end

  def article_breadcrumbs
    return [] unless @article

    [
      { name: "Articles", path: articles_path },
      { name: @article.titre, path: nil }
    ]
  end
end
