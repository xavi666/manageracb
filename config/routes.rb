Manageracb::Application.routes.draw do
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
  root :to => 'teams#index'

  resources :games do
    get 'create_from_html', on: :collection
  end
  resources :teams 
  resources :user_teams do
    get 'optimize', on: :collection
  end
  resources :players do
    collection do
      get 'money'
      get 'set_position'
      get 'list'
    end
  end
  resources :predictions do
    collection do
      get 'game'
      get 'predict'
      get 'init'
    end
  end
  resources :html_pages do
    collection do
      get 'import_games'
      get 'import_statistics'
    end
  end
  resources :statistics do
    collection do
      get 'create_from_html'
      get 'export'
      get 'acumulats_jugador'
      get 'acumulats_equip'
      get 'acumulats_equip_received'
    end
  end
  resources :optimizations

  #get '/predictions/:id/game', to: 'predictions#game', as: 'predictions_game'
  get '/home', to: 'home#index'

  get 'register' => 'users#new', as: 'register'
  get 'sign-in' => 'home#index', as: 'sign_in'
  delete 'sign-out' => 'sessions#destroy', as: 'sign_out'

  resources :users, only: [:new, :create, :show]
  resources :sessions, only: [:new, :create, :destroy]
  resources :password_resets, only: [:new, :create, :edit, :update]

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
