Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only:[] do
        get :current_user, action: :show, on: :collection
      end
    end
  end
end