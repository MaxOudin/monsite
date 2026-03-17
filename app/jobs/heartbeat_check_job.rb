# Job exécuté périodiquement par Solid Queue pour vérifier que le scheduler fonctionne.
# Log un message toutes les 10 minutes (config/recurring.yml).
class HeartbeatCheckJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "[HeartbeatCheckJob] Scheduler OK — #{Time.current.iso8601}"
  end
end
