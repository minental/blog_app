Rails.application.routes.draw do
  root 'posts#index'

  get    '/signup',     to: 'users#new'
  post   '/signup',     to: 'users#create'
  get    '/login',      to: 'sessions#new'
  post   '/login',      to: 'sessions#create'
  delete '/logout',     to: 'sessions#destroy'

  resources :users,      except: [:new, :create], constraints: { id: /\d+/ }
  resources :categories, except: [:new, :show]
  resources :posts,      except: [:new], constraints: { id: /\d+/ } do
    member do
      post :like
      post :dislike
    end
    resources :comments, except: [:new, :index, :show], constraints: { id: /\d+/ }
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
end
