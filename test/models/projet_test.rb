# == Schema Information
#
# Table name: projets
#
#  id            :bigint           not null, primary key
#  client        :string
#  couleur       :string
#  date_debut    :date
#  date_fin      :date
#  description   :text
#  github_lien   :string
#  image_url     :text
#  image_url_alt :string
#  projet_lien   :string
#  titre         :string
#  type_projet   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require "test_helper"

class ProjetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
