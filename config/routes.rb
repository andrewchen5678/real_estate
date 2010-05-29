ActionController::Routing::Routes.draw do |map|
  map.resources :companies, :collection=>{ :select => :get,:showrandom=>:get }, :member=>{:updatepics => :any,:agents=>:get,:showads=>:get,:recommend=>:get,:rate => :any} do |company|
    company.resources :assets
    company.resources :comments
    company.resources :events
  end

  map.resources :residential_realties, :collection=>{ :search => :any, :select => :get }, :member=>{:updatepics => :any} do |rr|
    rr.resources :assets
  end

  map.resources :commercial_realties

  map.resources :password_resets

  map.resources :addresses

  map.resources :businesses, :collection=>{ :search => :any }, :member=>{:updatepics => :any} do |buz|
    buz.resources :assets
    buz.resources :comments
  end

  map.resources :business_ads
  
  map.resources :rr_sales, :member=>{:email => :any, :showiframe=>:get} do |rr_sale_route|
    rr_sale_route.resources :comments
    rr_sale_route.resources :thumbs
  end

  map.resources :rr_rents

  map.resources :lands

  map.resource :user_session
  
  map.resource :account, :controller => "users"

  map.resources :user_auths
  
  map.resources :users, :member=>{:updatepics => :any,:showads=>:get,:showfavorites=>:get} do |user|
    user.resources :assets
    user.resources :comments
    user.resources :favorites
  end

  map.login 'login', :controller => 'user_sessions', :action => 'new'
  
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  
  #map.root :controller => "user_sessions", :action => "new" # optional, this just sets the root route

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.root :controller => "home" 
end
