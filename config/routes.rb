Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  #Rails.application.routes.draw do
  
  #map.connect '/trades/create', :controller => 'manage', :action => 'create'
  #map.connect '/trades/add_transaction', :controller => 'manage', :action => 'add_transaction'
  
  resources :users, only: [:new, :create, :index] do
    collection do
      get :login
      post :post_login # Not sure if this is actually needed. Need to check.
      get :logout
    end
  end
  
  resources :trades
  
  resources :manage, only: [:add_transaction, :create, :delete_transaction]
  

  #resources :display, only: [] do
  #  collection do
  #    get :main
  #    get :portfolio
  #    get :risk
  #    get :compliance
  #  end
  #end

  #resources :manage, only: [] do
  #  collection do
  #    get :add_transaction
  #  end
  #end

  # Upon loading the page, redirect to the portfolio action in the display controller
  root 'display#home'
  get ':controller(/:action(/:id))'
  post ':controller(/:action(/:id))'
end
