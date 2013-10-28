Alexandria::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :authors

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :strikes

  resources :checkouts

  resources :reservations

  resources :books do
    member do
      get 'put_away'
    end
  end

  resources :users

  match 'check_in', to: 'checkouts#check_in', via: [:get, :post]

  root 'root#index'
end
