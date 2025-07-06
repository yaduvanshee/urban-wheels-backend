Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/register", to: "users#create"
      post "/login", to: "auth#login"
      get "/auth/me", to: "auth#me"

      namespace :parking_spots do
        get "/search", to: "parkings#index"
        get "/:parking_id/vehicles", to: "parkings#list_vehicles"

        get "/rides/:vehicle_id", to: "ride#create_ride"
        get "/rides/:parking_id/complete/:ride_id", to: "ride#complete"
      end

      namespace :rides do
        get "my_ride", to: "ride#my_ride"
        get "history", to: "ride#history"
        get "vehicle_prices", to: "prices#index"
      end

      namespace :admin do
        get "/dashboard", to: "dashboard#index"
        get "/ride", to: "ride#index"
        get "/ride/parking_stats/:parking_id", to: "ride#parking_stats"
        get "/vehicle/:id/list_history", to: "vehicle#list_history"

        resources :prices, only: [ :index, :show, :update ]
        resources :vehicle, only: [ :index, :show, :create, :update, :destroy ]
      end
    end
  end
end
