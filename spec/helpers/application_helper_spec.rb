require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "#required_field?" do
    it "est vrai pour un attribut validé en présence (aligné NOT NULL)" do
      expect(helper.required_field?(Article.new, :titre)).to be true
      expect(helper.required_field?(Projet.new, :type_projet)).to be true
    end

    it "est faux pour un attribut optionnel" do
      expect(helper.required_field?(Projet.new, :couleur)).to be false
      expect(helper.required_field?(Projet.new, :client)).to be false
    end
  end

  describe "#required_mark" do
    it "rend une astérisque pour un champ obligatoire" do
      mark = helper.required_mark(Article.new, :titre)
      expect(mark).to include("*")
    end

    it "ne rend rien pour un champ optionnel" do
      expect(helper.required_mark(Projet.new, :couleur)).to be_nil
    end
  end
end
