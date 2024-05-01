# lib/tasks/modify_storage_config.rake

namespace :storage do
  desc "Modify storage configuration to get public access to files"
  task modify_config: :environment do
    # Parcourir tous les Blobs
    ActiveStorage::Blob.find_each do |blob|
      # Mettre à jour la configuration de chaque Blob
      blob.update(public: true)
    end
    puts "Configuration des Blobs mise à jour avec succès !"
  end
end
