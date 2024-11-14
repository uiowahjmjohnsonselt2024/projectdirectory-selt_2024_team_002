Rails.application.routes.draw do
  get 'users/login', to: 'users#login'
  post 'users/get-session', to: 'users#get_session'
  get 'users/logout'
  resources :users
end