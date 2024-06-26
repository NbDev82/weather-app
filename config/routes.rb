Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :weathers, only: [:index, :show, :create, :update, :destroy] do
        collection do
          get '' => 'weathers#get_weather'
          get 'forecast' => 'weathers#get_forecast_weather'
          get 'history' => 'weathers#get_history'
          get 'location' => 'weathers#get_location'
        end
      end

      resources :mailers, only: [:index, :show, :create, :destroy] do
        collection do
          get 'register' => 'mailers#register'
          get 'unsubscribe' => 'mailers#unsubscribe'
        end
      end
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
