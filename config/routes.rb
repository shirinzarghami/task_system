TaskSystem::Application.routes.draw do
  get "tags/index"

  devise_for :users, path_names: {sign_in: 'login', sign_up: 'register', sign_out: 'logout'}, controllers: {registrations: "registrations"}
  devise_scope :user do
    get "logout", :to => "devise/sessions#destroy"
  end
  namespace :admin do
    root to: 'Communities#index'
    resources :communities
    resources :users
  end

  resources :invitations, except: [:index]
  resources :communities, path: '', except: [:edit, :upgrade] do
    match 'payments/tags' => 'tags#index'
    resources :payments do
      resources :comments, only: [:create, :destroy]
    end
    resource :saldo, only: [:show], controller: 'saldo'
    resource :start_saldo_distribution, only: [:edit, :update]
    resources :community_users, only: [:show]
    resources :events
    resources :tasks do
      resources :task_occurrences, only: [:new, :create]
    end
    resources :task_occurrences, only: [:update, :create, :new, :edit, :destroy, :show] do
      resources :comments, only: [:create, :destroy]
      member do
        get :reassign
        get :complete
      end
    end

    get 'schedule/todo' => 'schedule#todo'
    get 'schedule/open' => 'schedule#open'
    get 'schedule/completed' => 'schedule#completed'
  end
  resources :community_users, only: [:update, :destroy]

  root :to => 'Communities#index'

  unless Rails.application.config.consider_all_requests_local
     match '*not_found', to: 'errors#error_404'
   end

end
