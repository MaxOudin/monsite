class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :nom
      t.text :description
      t.text :icone_url
      t.string :icone_url_alt
      t.string :couleur

      t.timestamps
    end
  end
end
