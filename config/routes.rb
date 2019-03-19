Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    resources :sections do
      collection do
        get :all
        get :all_visible
      end
    end

    resources :roles, only: %i[index create update] do
      collection do
        get :all
        get :my_role
      end
    end

    resources :users, only: %i[index create update] do
      collection do
        get :all
        get :statuses
      end
    end
  end
end
