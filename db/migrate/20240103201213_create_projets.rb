class CreateProjets < ActiveRecord::Migration[7.0]
  def change
    create_table :projets do |t|
      t.string :titre
      t.string :type_projet
      t.text :description
      t.text :image_url
      t.string :image_url_alt
      t.date :date_debut
      t.date :date_fin
      t.string :client
      t.string :projet_lien
      t.string :github_lien
      t.string :couleur

      t.timestamps
    end
  end
end
