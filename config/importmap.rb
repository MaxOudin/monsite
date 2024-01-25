# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# Popper CDN
pin "popper", to: 'popper.js', preload: true
# Bootstrap CDN
pin "bootstrap", to: "https://stackpath.bootstrapcdn.com/bootstrap/5.3.2/css/bootstrap.min.css", preload: true
pin "bootstrap.js", to: "https://stackpath.bootstrapcdn.com/bootstrap/5.3.2/js/bootstrap.min.js", preload: true

# Épingle pour les controllers de votre application
pin_all_from "app/javascript/controllers", under: "controllers"
