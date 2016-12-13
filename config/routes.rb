Rails.application.routes.draw do
  root 'static#home'

  get    '/signup',     to: 'users#new'
  post   '/signup',     to: 'users#create'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'

  resources :users,      only: [:index, :edit, :update, :show, :destroy]
  resources :posts,      only: [:index, :create, :show, :edit, :update, :destroy] do
    resources :comments,   only: [:create, :edit, :update, :destroy]
  end
end
