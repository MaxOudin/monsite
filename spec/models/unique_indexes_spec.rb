require 'rails_helper'

# Vérifie que les index uniques existent AU NIVEAU BASE (pas seulement via les
# validations applicatives, qui ne protègent pas des écritures concurrentes).
# On contourne les validations (save!(validate: false)) : la base doit lever
# une RecordNotUnique. Cf. documentation/09 branche 4.
RSpec.describe "Index uniques en base de données" do
  [
    [:service, :nom],
    [:sujet,   :nom],
    [:sujet,   :numero],
    [:projet,  :titre],
    [:article, :titre],
    [:outil,   :nom]
  ].each do |factory, column|
    it "rejette un doublon de #{factory}.#{column} au niveau base" do
      original  = create(factory)
      duplicate = build(factory, column => original.public_send(column))

      expect {
        duplicate.save!(validate: false)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
