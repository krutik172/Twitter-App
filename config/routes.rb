Rails.application.routes.draw do
  root 'static_page#home'
 
  get 'sessions/new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
 
  resources :users 
  resources :tweets do
  resources :comments 
  end

  resources :users do
    member do
      get :following,:followers
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :account_activations, only: [:edit]
  
end
