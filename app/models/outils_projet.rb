# == Schema Information
#
# Table name: outils_projets
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  outil_id   :bigint           not null
#  projet_id  :bigint           not null
#
# Indexes
#
#  index_outils_projets_on_outil_id   (outil_id)
#  index_outils_projets_on_projet_id  (projet_id)
#
# Foreign Keys
#
#  fk_rails_...  (outil_id => outils.id)
#  fk_rails_...  (projet_id => projets.id)
#
class OutilsProjet < ApplicationRecord
  belongs_to :outil
  belongs_to :projet
end
