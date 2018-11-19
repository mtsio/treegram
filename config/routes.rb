Rails.application.routes.draw do
  get '/' => 'home#index'
  resources :users do
    resources :photos
    resources :relations
  end
  
  resources :tags, only: [:create, :destroy]
  get '/log-in' => "sessions#new"
  post '/log-in' => "sessions#create"
  get '/log-out' => "sessions#destroy", as: :log_out
end
