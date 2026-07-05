# == Schema Information
#
# Table name: services
#
#  id            :integer          not null, primary key
#  nom           :string           not null
#  description   :text             not null
#  icone_url     :text
#  icone_url_alt :string
#  couleur       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_services_on_nom  (nom) UNIQUE
#

require 'rails_helper'

RSpec.describe Service, type: :model do
  it "a une factory valide" do
    expect(build(:service)).to be_valid
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:nom) }
    it { is_expected.to validate_presence_of(:description) }

    it "refuse un nom dupliqué" do
      create(:service, nom: "Développement web")
      expect(build(:service, nom: "Développement web")).not_to be_valid
    end

    it "refuse une description dupliquée" do
      create(:service, description: "Une description partagée.")
      expect(build(:service, description: "Une description partagée.")).not_to be_valid
    end
  end
end
