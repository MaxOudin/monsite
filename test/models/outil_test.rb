# == Schema Information
#
# Table name: outils
#
#  id            :bigint           not null, primary key
#  description   :text
#  icone_url     :string
#  icone_url_alt :string
#  nom           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  projet_id     :bigint
#
# Indexes
#
#  index_outils_on_projet_id  (projet_id)
#
# Foreign Keys
#
#  fk_rails_...  (projet_id => projets.id)
#
require "test_helper"

class OutilTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
