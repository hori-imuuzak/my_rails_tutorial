Rails.application.routes.draw do
  root 'static_pages#home' # => root_path
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get  '/signin',  to: 'sessions#new'
  post '/signin',  to: 'sessions#create'
  delete '/signout', to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]
end
