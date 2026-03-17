# Job récurrent : génère le sitemap (config/recurring.yml, ex. toutes les semaines).
# Réutilise la logique du rake task sitemap:refresh.
class GenerateSitemapJob < ApplicationJob
  queue_as :default

  def perform
    Rake::Task["sitemap:refresh"].reenable
    Rake::Task["sitemap:refresh"].invoke
    Rails.logger.info "[GenerateSitemapJob] Sitemap généré — #{Time.current.iso8601}"
  end
end
