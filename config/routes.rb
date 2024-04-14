Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "services#index"

  # Defines the "services" resources routes
  resources :services, only: [:index]

  # Defines the "projets" resources routes
  resources :projets
  get 'projets/:titre', to: 'projets#show', as: :projet_detail

  resources :articles
  get 'articles/:titre', to: 'articles#show', as: :article_detail

end
