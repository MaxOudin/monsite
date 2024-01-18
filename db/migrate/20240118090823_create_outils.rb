class CreateOutils < ActiveRecord::Migration[7.0]
  def change
    create_table :outils do |t|
      t.string :nom
      t.text :description
      t.string :icone_url
      t.string :icone_url_alt
      t.references :projet, foreign_key: true

      t.timestamps
    end
  end
end
