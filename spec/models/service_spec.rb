# == Schema Information
#
# Table name: services
#
#  id            :bigint           not null, primary key
#  couleur       :string
#  description   :text
#  icone_url     :text
#  icone_url_alt :string
#  nom           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

# validates :nom, presence: true, uniqueness: true
# validates :description, presence: true, uniqueness: true

# RSpec.describe Service, type: :model do

# end
