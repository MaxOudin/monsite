class AddUniqueIndexesToIdentityColumns < ActiveRecord::Migration[8.1]
  # Adosse les validations d'unicité applicatives à des index uniques DB, sur les
  # colonnes d'identité (courtes). Les colonnes `description` (text long) sont
  # volontairement exclues (limite btree ~2704 o + unicité métier discutable).
  # Cf. documentation/09 branche 4.
  def change
    add_index :services, :nom, unique: true
    add_index :sujets, :nom, unique: true
    add_index :sujets, :numero, unique: true
    add_index :projets, :titre, unique: true
    add_index :articles, :titre, unique: true
    add_index :outils, :nom, unique: true
  end
end
