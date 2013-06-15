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
    resources :payments
    resources :community_users, only: [:show]
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
    # resources :task_occurrences, path: 'schedule', except: [:index] do
    get 'schedule/todo' => 'schedule#todo'
    get 'schedule/open' => 'schedule#open'
    get 'schedule/completed' => 'schedule#completed'
  end
  resources :community_users, only: [:update, :destroy]

  root :to => 'Communities#index'

  unless Rails.application.config.consider_all_requests_local
     match '*not_found', to: 'errors#error_404'
   end
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
