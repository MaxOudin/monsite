# frozen_string_literal: true

class CardComponent < ViewComponent::Base
  def initialize(model:)
    @model = model
  end

  private

  def card_path
    helpers.polymorphic_path(@model)
  end

  def background_image
    if @model.image_url.present? && helpers.valid_url_or_asset?(@model.image_url)
      @model.image_url
    else
      helpers.image_path("assets/images/yellow_logo.svg")
    end
  end

  def overlay_color
    DEFAULT_META["card_overlay_color"]
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
end