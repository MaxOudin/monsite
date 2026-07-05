class RemoveProjetReferenceFromOutils < ActiveRecord::Migration[8.1]
  # Colonne + FK vestige : le modèle Outil ne déclare qu'une relation N-N avec
  # Projet (via outils_projets). La colonne outils.projet_id n'était utilisée par
  # aucun enregistrement ni par le code. Cf. documentation/09 branche 2.
  def change
    remove_reference :outils, :projet, foreign_key: true, index: true
  end
end
