Rails.application.routes.draw do
  get 'signups/create'
  get 'dishes/create'
  get 'dishes/edit'
  get 'dishes/update'
  get 'dishes/destroy'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  
  # Routes for piknik events
  resources :events, only: [:new, :create] do
    resources :dishes, except: [:index, :show]
  end
  
  # Admin route for event management
  get "/events/:id/admin", to: "events#admin", as: :admin_event
  
  # Participant route with code in URL for better sharing
  get "/events/:id/participate", to: "events#participate", as: :participate_event
  get "/events/:code/join", to: "events#show", as: :show_event
  
  # Backward compatibility route
  get "/events/:id", to: "events#show", as: :event
  
  # Routes for dish signups
  resources :dishes, only: [] do
    resources :signups, only: [:new, :create]
  end
  get "/join", to: "events#join", as: :join_event
  post "/attend", to: "events#attend", as: :attend_event
  
  # Routes for potluck system
  namespace :potluck do
    # Admin routes
    resources :events do
      member do
        get :admin, to: 'admin#show'
        get :toggle_notifications, to: 'admin#toggle_notifications'
        post :message_participant, to: 'admin#message_participant'
      end
      
      # Items management for admins
      resources :items do
        put :update_quantity, on: :member
      end
      
      # Activity dashboard for admins
      resource :activity, only: [:show]
    end
    
    # Participant routes
    get 'events/:token/participate', to: 'participants#show', as: :participate
    
    # Signup management for participants
    resources :signups, only: [:create, :update, :destroy] do
      member do
        get :confirm
      end
    end
  end
  
  # Route for confirming email addresses
  get 'confirm/:token', to: 'confirmations#confirm', as: :confirm
end
