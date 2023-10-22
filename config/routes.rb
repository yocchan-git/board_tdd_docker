Rails.application.routes.draw do
  get "users/new", to:"users#new"
  post "users/new", to:"users#create"
  get "users", to:"users#index"
  get "users/:id/edit", to:"users#edit"
  post "users/:id", to:"users#update"
  get "users/:id", to:"users#show"

  get "login", to:"sessions#new"
  post "login", to:"sessions#create"
  delete "logout", to:"sessions#destroy"

  get "comments/:post_id/new", to:"comments#new"
  post "comments/new", to:"comments#create"
  get "comments/:id/edit", to:"comments#edit"
  post "comments/:id/update", to:"comments#update"
  delete "comments/:id", to:"comments#destroy"

  post "likes/:post_id", to:"likes#create"
  delete "likes/:id", to:"likes#destroy"

  resources :posts
  resources :relationships, only: [:create, :destroy]
end
