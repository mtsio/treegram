Rails.application.routes.draw do
  get '/' => 'home#index'
  resources :users do
    resources :photos
    resources :relations
    resources :comments
    member do
      get 'slides'
    end
  end

  resources :tags, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]

  get '/log-in' => "sessions#new"
  post '/log-in' => "sessions#create"
  get '/log-out' => "sessions#destroy", as: :log_out
end
