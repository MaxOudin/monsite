require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Cd
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2
    config.action_view.image_loading = "lazy"

    # Please, add to the `ignore_exceptions_directories` list any directory inside your Rails app
    # where you are using `require` or `load` to execute Ruby code, so they don't cause a
    # reloading deadlock. Read more about Zeitwerk integration optimization:
    # https://guides.rubyonrails.org/classic_to_zeitwerk_howto.html#%3A%3Arequire-and-load
    config.add_autoload_paths_to_load_path = false

    # Add Rack Attack middleware
    config.middleware.use Rack::Attack

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
