
namespace :storage do
  desc "Modify storage configuration to get public access to files"
  task modify_config: :environment do
    # Parcourir tous les Blobs
    ActiveStorage::Blob.find_each do |blob|
      # Récupérez le service de stockage du Blob
      service = blob.service

      # Mettez à jour la valeur de public à true
      service.instance_variable_set(:@public, true)
      
      puts "Configuration du Blob ##{blob.id} mise à jour avec succès !"
    end
    p "Fin de la mise à jour des Blobs en public true"
  end
end
