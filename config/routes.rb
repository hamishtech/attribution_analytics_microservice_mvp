Rails.application.routes.draw do
  get 'signup_attributions/show'
  namespace :api do
    namespace :v1 do
      resources :pageviews, only: %i[create]
      resources :events, only: %i[create]

      get 'signup_attributions/:user_id', to: 'signup_attributions#show'
    end
  end
end
