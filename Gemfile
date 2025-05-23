source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.7"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Sassc-rails)
gem "sassc-rails"

gem "autoprefixer-rails"

# Authentification with Devise
gem 'devise', '~> 4.9.3'
gem "pundit", "~> 2.5"

gem 'devise-jwt'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Font-awesome Icones librairy import
gem "font-awesome-sass", "~> 6.1"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem 'aws-sdk-s3', require: false

gem 'friendly_id', '~> 5.5.0'

# Sitemap generator
gem 'sitemap_generator'

# Meta tags
gem 'meta-tags'

# API security
gem 'rack-attack'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # Pry pour débuggage
  # gem "pry-byebug"
  # gem "pry-rails"
  gem "byebug"

  gem "letter_opener"

  gem "dotenv-rails"
  gem 'annotate'
  gem "foreman"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

  # Helper pour avoir les informations des modèles dans les fichiers
  gem 'i18n', '1.14.5'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  # Tests + Factory Bot pour les tests
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "database_cleaner"

  # Helper pour les tests Models et Pundit
  gem "shoulda-matchers"
end