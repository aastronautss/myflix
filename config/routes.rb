Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get '/home', to: 'videos#index'
  get 'my_queue', to: 'queue_members#index'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end

    member do
      post 'add_to_queue', to: 'queue_members#create'
    end

    resources :reviews, only: [:create]
  end

  resources :users, only: [:create]
  resources :categories, only: [:show]
  resources :queue_members, only: [:destroy]
end
