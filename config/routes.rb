Myflix::Application.routes.draw do
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'

  get '/register', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/home', to: 'videos#index'

  resources :videos, only: [:index, :show] do
    collection do
      get 'search', to: 'videos#search'
    end

    resources :reviews, only: [:create]
  end

  resources :users, only: [:create]

  resources :categories, only: [:show]
end
