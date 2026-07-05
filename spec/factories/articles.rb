# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  titre      :string
#  image_url  :string
#  image_alt  :string
#  couleur    :string
#  theme      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#
# Indexes
#
#  index_articles_on_slug  (slug) UNIQUE
#

FactoryBot.define do
  factory :article do
    sequence(:titre) { |n| "Article #{n}" }
    content { "<p>Contenu de l'article de test.</p>" }
    image_url { "https://example.com/image.png" }
    image_alt { "Illustration de l'article" }
    couleur { "#18435A" }
    theme { "Autour du web" }
  end
end
