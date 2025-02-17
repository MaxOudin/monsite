# == Schema Information
#
# Table name: projets
#
#  id            :integer          not null, primary key
#  titre         :string
#  type_projet   :string
#  description   :text
#  image_url     :text
#  image_url_alt :string
#  date_debut    :date
#  date_fin      :date
#  client        :string
#  projet_lien   :string
#  github_lien   :string
#  couleur       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#
# Indexes
#
#  index_projets_on_slug  (slug) UNIQUE
#

require 'rails_helper'

RSpec.describe Projet, type: :model do
  it "Model projet, with outils:" do
    projet = FactoryBot.create(:projet)
    outil = FactoryBot.create(:outil, projet: projet)
    expect(projet.outils).to eq([outil])
    
  end
end
