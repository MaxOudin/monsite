# == Schema Information
#
# Table name: projets
#
#  id            :bigint           not null, primary key
#  client        :string
#  couleur       :string
#  date_debut    :date
#  date_fin      :date
#  description   :text
#  github_lien   :string
#  image_url     :text
#  image_url_alt :string
#  projet_lien   :string
#  titre         :string
#  type_projet   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Projet, type: :model do
  it "Model projet, with outils:" do
    projet = FactoryBot.create(:projet)
    outil = FactoryBot.create(:outil, projet: projet)
    expect(projet.outils).to eq([outil])
    
  end
end
