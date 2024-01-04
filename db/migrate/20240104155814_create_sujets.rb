class CreateSujets < ActiveRecord::Migration[7.0]
  def change
    create_table :sujets do |t|
      t.string :nom
      t.text :description
      t.integer :numero
      t.string :couleur
      t.text :icone_url
      t.string :icone_url_alt

      t.timestamps
    end
  end
end
