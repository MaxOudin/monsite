# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(model:)
    @model = model
  end

  private

  def card_path
    helpers.polymorphic_path(@model)
  end

  def has_custom_image?
    @model.image_url.present? && helpers.valid_url_or_asset?(@model.image_url)
  end

  def image_src
    has_custom_image? ? @model.image_url : helpers.image_path("yellow_logo.svg")
  end

  def image_alt
    return @model.titre unless has_custom_image?

    case @model
    when Projet
      @model.image_url_alt.presence || @model.titre
    when Article
      @model.image_alt.presence || @model.titre
    else
      @model.titre
    end
  end

  def formatted_date
    case @model
    when Projet
      @model.date_debut.present? ? helpers.l(@model.date_debut, format: :abbr_month_year) : "Projet récent"
    when Article
      helpers.l(@model.created_at.to_date, format: :abbr_month_year)
    end
  end

  def badge_text
    case @model
    when Projet
      @model.type_projet.titleize
    when Article
      @model.theme
    end
  end

  def excerpt
    text = case @model
    when Projet
      @model.description
    when Article
      @model.content.to_plain_text
    end

    helpers.truncate(text.to_s.squish, length: 110)
  end
end
