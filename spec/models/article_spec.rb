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

require 'rails_helper'

RSpec.describe Article, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
