# == Schema Information
#
# Table name: outils_projets
#
#  id         :integer          not null, primary key
#  outil_id   :integer          not null
#  projet_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_outils_projets_on_outil_id   (outil_id)
#  index_outils_projets_on_projet_id  (projet_id)
#

class OutilsProjet < ApplicationRecord
  belongs_to :outil
  belongs_to :projet
end
