Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :auctions do
    resources :bids
    resources :publishings, only: :create
    resources :watches, only: [:index, :create, :destroy]
  end

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create] do
   delete :destroy, on: :collection
  end

  get '/' => "auctions#index", as: :home

end
