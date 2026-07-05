# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  titre      :string           not null
#  image_url  :string           not null
#  image_alt  :string           not null
#  couleur    :string           not null
#  theme      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  slug       :string
#
# Indexes
#
#  index_articles_on_slug   (slug) UNIQUE
#  index_articles_on_titre  (titre) UNIQUE
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
