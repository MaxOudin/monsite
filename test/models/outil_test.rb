# == Schema Information
#
# Table name: outils
#
#  id            :integer          not null, primary key
#  nom           :string
#  description   :text
#  icone_url     :string
#  icone_url_alt :string
#  projet_id     :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_outils_on_projet_id  (projet_id)
#

require "test_helper"

class OutilTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
