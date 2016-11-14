Myflix::Application.routes.draw do
  mount StripeEvent::Engine, at: '/stripe_events'

  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'

  # ====-----------------------====
  # Login and Register
  # ====-----------------------====

  get '/register', to: 'users#new'
  get '/register/:token', to: 'users#new_with_invitation', as: 'register_with_invitation'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get 'inactive_account', to: 'pages#inactive_account'

  # ====-----------------------====
  # Password Resets
  # ====-----------------------====

  get 'forgot_password', to: 'forgot_passwords#new'
  get 'confirm_password_reset', to: 'forgot_passwords#confirm'
  get 'invalid_token', to: 'password_resets#invalid_token'

  # ====-----------------------====
  # User Stuff
  # ====-----------------------====

  get '/home', to: 'videos#index'
  get 'my_queue', to: 'queue_members#index'
  post 'update_queue', to: 'queue_members#update_queue'
  get 'people', to: 'followings#index'

  # ====-----------------------====
  # Invites
  # ====-----------------------====

  get 'invite', to: 'invites#new'
  post 'invite', to: 'invites#create'

  # ====-----------------------====
  # Videos
  # ====-----------------------====

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
      get 'advanced_search', to: 'videos#advanced_search'
    end

    member do
      post 'add_to_queue', to: 'queue_members#create'
    end

    resources :reviews, only: [:create]
  end

  # ====-----------------------====
  # Users and Following
  # ====-----------------------====

  resources :users, only: [:show, :create] do
    member do
      post 'follow', to: 'followings#create'
      delete 'unfollow', to: 'followings#destroy'
    end
  end

  # ====-----------------------====
  # Admin
  # ====-----------------------====

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  # ====-----------------------====
  # Other Resources
  # ====-----------------------====

  resources :categories, only: [:show]
  resources :queue_members, only: [:destroy]
  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
end
