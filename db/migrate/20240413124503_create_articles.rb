class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :titre
      t.string :image_url
      t.string :image_alt
      t.string :couleur
      t.string :theme
      t.text :description

      t.timestamps
    end
  end
end
