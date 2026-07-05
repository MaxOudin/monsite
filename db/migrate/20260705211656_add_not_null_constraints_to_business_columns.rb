class AddNotNullConstraintsToBusinessColumns < ActiveRecord::Migration[8.1]
  # Adosse les validations de présence applicatives à des contraintes DB.
  # ⚠️ En prod : auditer d'éventuelles lignes NULL avant d'appliquer (la migration
  # échoue s'il en existe). Cf. documentation/09 branche 3.
  def change
    change_column_null :services, :nom, false
    change_column_null :services, :description, false

    change_column_null :sujets, :nom, false
    change_column_null :sujets, :description, false
    change_column_null :sujets, :numero, false

    change_column_null :projets, :titre, false
    change_column_null :projets, :type_projet, false
    change_column_null :projets, :description, false

    change_column_null :articles, :titre, false
    change_column_null :articles, :theme, false
    change_column_null :articles, :image_url, false
    change_column_null :articles, :image_alt, false
    change_column_null :articles, :couleur, false

    change_column_null :outils, :nom, false
    change_column_null :outils, :description, false
  end
end
