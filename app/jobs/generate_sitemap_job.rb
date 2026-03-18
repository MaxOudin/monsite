# Job récurrent : génère le sitemap (config/recurring.yml, ex. toutes les semaines).
# Réutilise la logique du rake task sitemap:refresh.
class GenerateSitemapJob < ApplicationJob
  queue_as :default

  def perform
    require "rake"
    Rails.application.load_tasks
    Rake::Task["sitemap:refresh:no_ping"].reenable
    Rake::Task["sitemap:refresh:no_ping"].invoke
    Rails.logger.info "[GenerateSitemapJob] Sitemap généré — #{Time.current.iso8601}"
  end
end
