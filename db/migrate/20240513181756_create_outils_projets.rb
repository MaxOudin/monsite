class CreateOutilsProjets < ActiveRecord::Migration[7.1]
  def change
    create_table :outils_projets do |t|
      t.references :outil, null: false, foreign_key: true
      t.references :projet, null: false, foreign_key: true

      t.timestamps
    end
  end
end

