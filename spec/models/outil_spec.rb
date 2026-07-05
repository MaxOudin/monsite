# == Schema Information
#
# Table name: outils
#
#  id            :integer          not null, primary key
#  nom           :string           not null
#  description   :text             not null
#  icone_url     :string
#  icone_url_alt :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_outils_on_nom  (nom) UNIQUE
#

require 'rails_helper'

RSpec.describe Outil, type: :model do
  it "a une factory valide" do
    expect(build(:outil)).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:nom) }
    it { is_expected.to validate_presence_of(:description) }

    it "refuse un nom dupliqué" do
      create(:outil, nom: "Ruby on Rails")
      expect(build(:outil, nom: "Ruby on Rails")).not_to be_valid
    end

    it "refuse une description dupliquée" do
      create(:outil, description: "Une description partagée.")
      expect(build(:outil, description: "Une description partagée.")).not_to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:outils_projets) }
    it { is_expected.to have_many(:projets).through(:outils_projets) }

    it "est relié à ses projets via la table de jointure" do
      outil = create(:outil, :with_projet)
      expect(outil.projets.count).to eq(1)
    end

    it "ne déclare pas de belongs_to :projet (colonne projet_id supprimée en branche 2)" do
      expect(described_class.reflect_on_association(:projet)).to be_nil
    end
  end
end
