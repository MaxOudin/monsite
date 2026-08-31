# frozen_string_literal: true

require "rails_helper"

RSpec.describe ButtonComponent, type: :component do
  it "rend le contenu passé en bloc" do
    rendered = render_inline(described_class.new) { "Envoyer" }
    expect(rendered.css("button").text).to include("Envoyer")
  end

  it "applique le variant primary par défaut" do
    rendered = render_inline(described_class.new) { "OK" }
    expect(rendered.to_html).to include("bg-primary")
  end

  it "applique le variant demandé" do
    rendered = render_inline(described_class.new(variant: :danger)) { "Supprimer" }
    expect(rendered.to_html).to include("bg-red-600")
  end

  it "affiche une icône quand elle est fournie" do
    rendered = render_inline(described_class.new(icon: "fa-check")) { "OK" }
    expect(rendered.css("i.fa-check")).to be_present
  end

  it "lève une erreur pour un variant inconnu" do
    expect {
      render_inline(described_class.new(variant: :inconnu)) { "X" }
    }.to raise_error(KeyError)
  end

  it "applique text-secondary sur le variant primary" do
    rendered = render_inline(described_class.new(variant: :primary)) { "OK" }
    expect(rendered.to_html).to include("text-secondary")
  end

  it "applique rounded-full et h-12 pour shape pill en taille lg" do
    rendered = render_inline(described_class.new(variant: :primary, shape: :pill, size: :lg)) { "Me contacter" }
    html = rendered.to_html
    expect(html).to include("rounded-full")
    expect(html).to include("h-12")
    expect(html).to include("font-medium")
    expect(html).not_to include("shadow-md")
  end

  it "rend un lien pour le variant link" do
    rendered = render_inline(described_class.new(variant: :link, size: :sm, href: "/projets")) { "Voir" }
    expect(rendered.css("a[href='/projets']")).to be_present
    expect(rendered.to_html).to include("hover:text-secondary")
    expect(rendered.to_html).to include("btn-link")
  end

  it "rend un lien quand href est fourni sur un variant filled" do
    rendered = render_inline(described_class.new(href: "#contact-infos")) { "Contact" }
    expect(rendered.css("a[href='#contact-infos']")).to be_present
    expect(rendered.css("button")).to be_empty
  end
end
