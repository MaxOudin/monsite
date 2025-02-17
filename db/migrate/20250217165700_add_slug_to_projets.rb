class AddSlugToProjets < ActiveRecord::Migration[8.0]
  def change
    add_column :projets, :slug, :string
    add_index :projets, :slug, unique: true
  end
end
