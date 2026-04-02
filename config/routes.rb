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

  # Image Tools
  get  "tools",                to: "tools#index",              as: :tools
  get  "tools/resize",         to: "tools#resize",             as: :tools_resize
  post "tools/resize",         to: "tools#process_resize",     as: :tools_process_resize
  get  "tools/convert",        to: "tools#convert",            as: :tools_convert
  post "tools/convert",        to: "tools#process_convert",    as: :tools_process_convert
  get  "tools/remove_bg",      to: "tools#remove_bg",          as: :tools_remove_bg
  post "tools/remove_bg",      to: "tools#process_remove_bg",  as: :tools_process_remove_bg
  get  "tools/favicon",        to: "tools#favicon",            as: :tools_favicon
  post "tools/favicon",        to: "tools#process_favicon",    as: :tools_process_favicon
  # Pages statiques
  get "/mentions-legales", to: "pages#mentions_legales", as: :mentions_legales
  get "/cgv", to: "pages#cgv", as: :cgv

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
