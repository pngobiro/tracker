Case::Application.routes.draw do



scope 'tracks' do

resources :courtstations do
resources :batches
end


resources :sms

get 'courtstations:id', to: 'courtstations#stationmovements', as: :station



resources :courtstations do
  resources :casefiles do
 collection do
    match 'search' => 'casefiles#search', via: [:get, :post], as: :search
  end
    resources :movements do
  end
end
end

  devise_for :users




  resources :judicial_officers


  devise_for :admins

  get "dashboard/audit"
get "dashboard/login"
get "admin/index"
get "dashboard/index"
get "dashboard/useractivity"
get "dashboard/mini_dashboard"
get "dashboard/caselistreport"
get "dashboard/casestatusreports"

  #get "dashboard/courtcalender"


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  # match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  # resources :products

  # Sample resource route with options:
  # resources :products do
  # member do
  # get 'short'
  # post 'toggle'
  # end
  #
  # collection do
  # get 'sold'
  # end
  # end

  # Sample resource route with sub-resources:
  # resources :products do
  # resources :comments, :sales
  # resource :seller
  # end

  # Sample resource route with more complex sub-resources
  # resources :products do
  # resources :comments
  # resources :sales do
  # get 'recent', :on => :collection
  # end
  # end

  # Sample resource route within a namespace:
  # namespace :admin do
  # # Directs /admin/products/* to Admin::ProductsController
  # # (app/controllers/admin/products_controller.rb)
  # resources :products
  # end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   
 root :to => 'courtstations#index'
  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
end



