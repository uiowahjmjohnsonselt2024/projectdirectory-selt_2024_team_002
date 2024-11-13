Rails.application.routes.draw do
  resources :users
  get 'users/login'
  post 'users/get-session', to: 'users#get_session'
  get 'users/logout'
end