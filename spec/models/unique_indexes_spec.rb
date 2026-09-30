require "rails_helper"

# Vérifie que les index uniques existent AU NIVEAU BASE (pas seulement via les
# validations applicatives, qui ne protègent pas des écritures concurrentes).
# On contourne les validations (save!(validate: false)) : la base doit lever
# une RecordNotUnique. Cf. documentation/09 branche 4.
RSpec.describe "Index uniques en base de données" do
  [
    %i[service nom],
    %i[sujet nom],
    %i[sujet numero],
    %i[projet titre],
    %i[article titre],
    %i[outil nom]
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
