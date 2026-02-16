Rails.application.routes.draw do
  post "/csp-violation-report-endpoint", to: "csp_reports#create", as: :csp_violation_report_endpoint
  
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "services#index"

  # Defines the "services" resources routes
  resources :services, only: [:index]

  # Defines the "projets" resources routes
  resources :projets, path: 'projets'
  resources :articles, path: 'articles'

  # Sitemap - accessible pour les moteurs de recherche
  get '/sitemaps/sitemap.xml.gz', to: 'sitemaps#show', as: :sitemap
  get "/sitemap.xml.gz", to: "sitemaps#show"

  # Routes API
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :articles, only: [:index, :show, :update, :create, :destroy]
      
      # Routes d'authentification
      devise_scope :user do
        post '/login', to: 'sessions#create'
        post '/refresh', to: 'sessions#refresh'
        delete '/logout', to: 'sessions#destroy'
      end
    end
  end
end
