require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cd
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.importmap.enabled = true
    config.action_view.image_loading = "lazy"

    config.generators do |g|
      g.test_framework(
      :rspec,
      fixtures: false,
      view_specs: false,
      helper_specs: false,
      routing_specs: false
      )
      g.factory_bot false
    end
  end
end
