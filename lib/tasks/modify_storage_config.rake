
namespace :storage do
  desc "Modify storage configuration to get public access to files"
  task modify_config: :environment do
    # Parcourir tous les Blobs
    ActiveStorage::Blob.find_each do |blob|
      # Mettre à jour la configuration de chaque Blob
      blob.update(service_metadata: { public: true })
      puts "Configuration du Blob ##{blob.id} mise à jour avec succès !"
    end
    p "Fin de la mise à jour des Blobs en public true"
  end
end
