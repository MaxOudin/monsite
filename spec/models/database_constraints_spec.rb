require 'rails_helper'

# Vérifie que les contraintes NOT NULL existent bien AU NIVEAU BASE (et pas
# seulement via les validations applicatives). On contourne les validations avec
# update_column (SQL direct) : la base doit lever une NotNullViolation.
# Cf. documentation/09 branche 3.
RSpec.describe "Contraintes NOT NULL en base de données" do
  {
    Service => %i[nom description],
    Sujet   => %i[nom description numero],
    Projet  => %i[titre type_projet description],
    Article => %i[titre theme image_url image_alt couleur],
    Outil   => %i[nom description]
  }.each do |model, columns|
    context model.name do
      let(:factory_name) { model.name.underscore.to_sym }

      columns.each do |column|
        it "rejette #{column} NULL au niveau base" do
          record = create(factory_name)

          expect {
            record.update_column(column, nil)
          }.to raise_error(ActiveRecord::NotNullViolation)
        end
      end
    end
  end
end
