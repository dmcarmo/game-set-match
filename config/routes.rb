Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  devise_scope :user do
    authenticated :user do
      root "dashboards#show", as: :authenticated_root
    end

    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "pages#home"

  resources :groups, except: :index do
    # resources :memberships, only: %i[create destroy]
    resources :invitations, only: %i[new create]
  end
  get "join/:token", to: "groups#join", as: "join_group"

  resources :invitations, only: [] do
    member do
      patch "accept"
      patch "decline"
    end
  end

  resources :availabilities, except: %i[index show]

  # resources :memberships, only: [:destroy]
end
