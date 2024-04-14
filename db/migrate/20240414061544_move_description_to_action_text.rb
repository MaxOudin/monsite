class MoveDescriptionToActionText < ActiveRecord::Migration[7.1]
  def change
    Article.all.find_each do |article|
      article.update!(content: article.description)
    end

    remove_column :articles, :description
  end
end
