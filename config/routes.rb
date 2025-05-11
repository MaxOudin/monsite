Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "services#index"

  # Defines the "services" resources routes
  resources :services, only: [:index]

  # Defines the "projets" resources routes
  resources :projets, path: 'projets'
  resources :articles, path: 'articles'

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
