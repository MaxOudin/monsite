# == Schema Information
#
# Table name: services
#
#  id            :integer          not null, primary key
#  nom           :string
#  description   :text
#  icone_url     :text
#  icone_url_alt :string
#  couleur       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
