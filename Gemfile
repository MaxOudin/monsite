source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.8"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.1", ">= 8.1.3.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 7.2", ">= 7.2.1"

gem "kamal"

# Use Propshaft for asset pipeline
gem "propshaft"

# Use JavaScript bundling with Bun [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Use CSS bundling with Tailwind CSS
gem "cssbundling-rails"

# Use Tailwind CSS for styling
gem "tailwindcss-rails", "~> 4.3"
gem "tailwindcss-ruby", "~> 4.1"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Authentification with Devise
gem "devise", "~> 4.9.3"
gem "pundit", "~> 2.5"

gem "devise-jwt"
gem "devise-two-factor"
gem "rqrcode"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Archives ZIP (favicon, traitement groupé) — série 3.x corrigée
gem "rubyzip", ">= 3.4.0", "< 4"

gem "aws-sdk-s3", require: false

gem "friendly_id", "~> 5.5.0"

# Full-text search with PostgreSQL
gem "pg_search", "~> 2.3"

# Sitemap generator
gem "sitemap_generator"

# Meta tags
gem "meta-tags"

# API security
gem "rack-attack"

gem "view_component"

# solid
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"

gem "sentry-rails"
gem "sentry-ruby"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mingw x64_mingw]

  gem "letter_opener"

  gem "annotate"
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "dotenv-rails"
  gem "foreman"

  gem "rubocop", require: false
  gem "rubocop-performance", require: false
  gem "rubocop-rails", require: false
  gem "rubocop-rspec", require: false
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  # Tests + Factory Bot pour les tests
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "rspec-rails"

  # Helper pour les tests Models et Pundit
  gem "shoulda-matchers"
end
