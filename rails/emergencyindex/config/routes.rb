Rails.application.routes.draw do
  
  get 'admin', to: 'admin#index'
  get 'admin/users', to: 'admin#users'
  post 'admin/new_volume', to: 'admin#new_volume'

  devise_for :users, path_names: { 
    sign_in:  'login', 
    sign_out: 'logout', 
    sign_up:  'register' 
  }
  #devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }

  root to: "home#index"

  resources :projects
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
