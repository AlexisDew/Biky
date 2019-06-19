Rails.application.routes.draw do
  root to: 'pages#home'

  get  'construction', to: 'pages#construction', as: :construction
  get  'cgu', to: 'pages#cgu', as: :cgu

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :bikes do
    resources :bookings, only: [:new, :create]
  end
end
