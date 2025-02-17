# == Schema Information
#
# Table name: projets
#
#  id            :integer          not null, primary key
#  titre         :string
#  type_projet   :string
#  description   :text
#  image_url     :text
#  image_url_alt :string
#  date_debut    :date
#  date_fin      :date
#  client        :string
#  projet_lien   :string
#  github_lien   :string
#  couleur       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  slug          :string
#
# Indexes
#
#  index_projets_on_slug  (slug) UNIQUE
#

require "test_helper"

class ProjetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
