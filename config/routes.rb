Catchup::Application.routes.draw do
  resources :users do
    resources :meetings
    match '/show_list',            to: "meetings#show_list"
    match '/show_map',             to: "meetings#show_map"
    match '/new_with_email',       to: "meetings#new_with_email"
    match '/create_with_email',    to: "meetings#create_with_email"
    match '/new_with_contact',     to: "meetings#new_with_contact"
    match '/update_catch_up_page', to: "meetings#update_page"
    match '/update_position',      to: "meetings#update_position"
    match '/confirm_meeting',      to: "meetings#confirm"
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :infos,    only: [:new, :create, :destroy]

  # The priority is based upon order of creation:
  # first created -> highest priority.
  root :to => 'static_pages#start'

  match '/signup',    to: 'users#new'
  match '/signin',    to: 'sessions#new'
  match '/signout',   to: 'sessions#destroy', via: :delete

  match '/start',     to: "static_pages#start"
  match '/new',       to: "static_pages#new_catchup"
  match '/contacts',  to: "users#show_contacts"
  match '/help',      to: "static_pages#help"



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


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
