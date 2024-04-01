require 'rails_helper'

RSpec.describe Projet, type: :model do
  it "Model projet, with outils:" do
    projet = FactoryBot.create(:projet)
    outil = FactoryBot.create(:outil, projet: projet)
    expect(projet.outils).to eq([outil])
    
  end
end
