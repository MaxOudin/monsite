json.array! @articles do |article|
  json.extract! article, :id, :titre, :theme, :image_url, :image_alt, :couleur, :created_at, :updated_at, :slug
  json.content article.content.to_plain_text
  json.content_html article.content.body.to_html
end