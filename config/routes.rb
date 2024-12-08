# frozen_string_literal: true
# rubocop:disable all

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
  # displays page where the user will enter reset email
  get 'users/forgot-password', to: 'users#forgot_password', as: 'forgot_password'
  post 'users/send-reset-email', to: 'users#send_reset_email', as: 'send_reset_email' # sends reset email
  # displays page where the user will enter new password
  get 'users/reset-password', to: 'users#reset_password', as: 'reset_password'
  post 'users/update-password', to: 'users#update_password' # resets password
  get 'users/purchase_plus_user_view', to: 'users#purchase_plus_user_view'
  post 'users/purchase_plus_user', to: 'users#purchase_plus_user'
  resources :users

  # routes for worlds
  post 'worlds/join_world', to: 'worlds#join_world'
  post 'worlds/leave_world', to: 'worlds#leave_world'
  resources :worlds
  root to: redirect('/worlds')
  mount GoodJob::Engine => 'good_job' if ENV['RAILS_ENV'] != 'production'
  # routes for game
  post '/worlds/game/cell_quest', to: 'users_worlds#cell_quest', as: 'cell_quest'
  post '/worlds/game/cell_action', to: 'users_worlds#cell_action', as: 'cell_action'
  post '/worlds/game/cell_shop', to: 'users_worlds#cell_shop', as: 'cell_shop'
end
