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
  get 'users/reset-password', to: 'users#reset_password', as: 'reset_password'
  post 'users/reset-password', to: 'users#reset_password_post'
  get 'users/forgot-password/', to: 'users#forgot_password', as: 'forgot_password'
  post 'users/forgot-password/', to: 'users#forgot_password_post'
  get 'users/purchase_plus_user_view', to: 'users#purchase_plus_user_view'
  post 'users/purchase_plus_user', to: 'users#purchase_plus_user'
  resources :users

  # routes for worlds
  post 'worlds/join_world', to: 'worlds#join_world'
  post 'worlds/leave_world', to: 'worlds#leave_world'
  resources :worlds
  root to: redirect('/worlds')
end
