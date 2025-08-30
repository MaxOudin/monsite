# Utiliser une image Ruby officielle comme base
FROM ruby:3.3.7-slim as base

# Définir l'environnement de production
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# Étape de build pour installer les gems
FROM base as build

# Install packages needed to build gems and node modules
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libvips \
    pkg-config \
    python-is-python3 \
    libyaml-dev \
    libpq-dev \
    libgmp-dev \
    nodejs

# Install application gems
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Final stage for app image
FROM base

# Installer les dépendances nécessaires pour l'exécution
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Définir le répertoire de travail
WORKDIR /app

# Copier le Gemfile et installer les gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copier le reste de l'application
COPY . .

# Précompiler les assets
RUN SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Étape finale pour l'image de production
FROM base

# Installer les dépendances nécessaires pour l'exécution
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Définir le répertoire de travail
WORKDIR /app

# Copier les gems et l'application depuis l'étape de build
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

# Créer un utilisateur non-root pour exécuter l'application
RUN useradd rails --create-home --shell /bin/bash

ENV PATH="/app/bin:${PATH}"
RUN chown -R rails:rails /app && \
    chmod +x /app/bin/*

# Définir l'utilisateur pour exécuter le conteneur
USER rails

# Définir le répertoire de travail
WORKDIR /app

# Exposer le port 3000
EXPOSE 3001

# Commande pour démarrer le serveur Rails
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3001"]