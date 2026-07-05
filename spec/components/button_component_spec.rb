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
end
