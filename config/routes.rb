Alexandria::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :authors

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resources :strikes

  resources :checkouts

  get 'checkout', to: 'checkouts#checkout', as: :check_out
  get 'checkin', to: 'checkouts#check_in', as: :check_in

  resources :reservations

  resources :books do
    member do
      get 'put_away'
    end
  end

  resources :users

  root 'root#index'
end
