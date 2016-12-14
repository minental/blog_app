Rails.application.routes.draw do
  root 'static#home'

  get    '/signup',     to: 'users#new'
  post   '/signup',     to: 'users#create'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'

  resources :users,      except: [:new, :create]
  resources :posts,      except: [:new] do
    resources :comments, except: [:new, :index, :show]
  end
end
