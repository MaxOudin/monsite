# == Schema Information
#
# Table name: sujets
#
#  id            :integer          not null, primary key
#  nom           :string
#  description   :text
#  numero        :integer
#  couleur       :string
#  icone_url     :text
#  icone_url_alt :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "test_helper"

class SujetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
