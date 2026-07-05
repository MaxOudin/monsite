# == Schema Information
#
# Table name: sujets
#
#  id            :integer          not null, primary key
#  nom           :string           not null
#  description   :text             not null
#  numero        :integer          not null
#  couleur       :string
#  icone_url     :text
#  icone_url_alt :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_sujets_on_nom     (nom) UNIQUE
#  index_sujets_on_numero  (numero) UNIQUE
#

require 'rails_helper'

RSpec.describe Sujet, type: :model do
  it "a une factory valide" do
    expect(build(:sujet)).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:nom) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:numero) }

    it "refuse un nom dupliqué" do
      create(:sujet, nom: "Introduction")
      expect(build(:sujet, nom: "Introduction")).not_to be_valid
    end

    it "refuse une description dupliquée" do
      create(:sujet, description: "Une description partagée.")
      expect(build(:sujet, description: "Une description partagée.")).not_to be_valid
    end

    it "refuse un numero dupliqué" do
      create(:sujet, numero: 42)
      expect(build(:sujet, numero: 42)).not_to be_valid
    end
  end
end
