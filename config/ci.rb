# Run using bin/ci

CI.run do
  step "Setup", "bin/setup --skip-server"

  step "Style: RuboCop", "bundle exec rubocop"
  step "Security: Brakeman", "bin/brakeman --no-pager"
  step "Security: bundler-audit", "bin/bundler-audit"
  step "Tests: Seeds", "env RAILS_ENV=test bin/rails db:seed:replant"
end
