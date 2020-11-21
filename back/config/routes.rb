Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users do
        get :current_user, action: :my_page, on: :collection
        get :user_data, action: :user_data, on: :collection
      end
    
      
      # login, logout
      resources :user_token, only: [:create] do
        delete :destroy, on: :collection
      end
      resources :spots do
        collection do
          get 'ranking'
        end
        resources :reviews do
          resources :likes, only: [:create, :destroy]
        end
      end
      resources :locations
      resources :prefectures
      resources :relationships, only: [:create, :destroy]
    end
  end
end