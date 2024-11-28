# frozen_string_literal: true

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

  # landing page

  # routes for users
  get 'users/login', to: 'users#login'
  post 'users/get-session', to: 'users#get_session'
  get 'users/logout'
  get 'users/purchase', to: 'users#purchase'
  post 'users/conversion', to: 'users#conversion', defaults: { format: 'js' }
  get 'users/checkout', to: 'users#checkout'
  post 'users/checkout', to: 'users#checkout'
  post 'users/payment', to: 'users#payment', defaults: { format: 'js' }
  post 'users/add_friend', to: 'users#add_friend', defaults: { format: 'js' }
  delete 'users/delete_friend', to: 'users#delete_friend', defaults: { format: 'js' }
  post 'users/approve_request', to: 'users#approve_request', defaults: { format: 'js' }
  delete 'users/reject_request', to: 'users#reject_request', defaults: { format: 'js' }

  resources :users

  # routes for worlds
  post 'worlds/join_world', to: 'worlds#join_world'
  resources :worlds
  root to: redirect('/worlds')

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
end
