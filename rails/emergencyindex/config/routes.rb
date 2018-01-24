Rails.application.routes.draw do
  
  get 'admin', to: 'admin#index'

  get 'admin/users-list', to: 'admin#users_list'
  post 'admin/new_user', to: 'admin#new_user'
  delete 'admin/delete_user', to: 'admin#delete_user'
  get 'admin/user_edit', to: 'admin#user_edit'
  patch 'admin/update_user', to: 'admin#update_user'
  post 'admin/resend_user_confirmation', to: 'admin#resend_user_confirmation'
  post 'admin/reset_user_password', to: 'admin#reset_user_password'
  post 'admin/user_admin', to: 'admin#user_admin'

  post 'admin/new_volume', to: 'admin#new_volume'
  get 'admin/edit_volume', to: 'admin#edit_volume'
  patch 'admin/update_volume', to: 'admin#update_volume'
  delete 'admin/delete_volume', to: 'admin#delete_volume'

  get 'admin/projects-list', to: 'admin#projects_list'
  delete 'admin/delete_project', to: 'admin#delete_project'
  post 'admin/project_toggle_publish', to: 'admin#project_toggle_publish'

  devise_for :users, path_names: { 
    sign_in:  'login', 
    sign_out: 'logout', 
    sign_up:  'register' 
  }
  #devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', password: 'secret', confirmation: 'verification', unlock: 'unblock', registration: 'register', sign_up: 'cmon_let_me_in' }

  root to: "home#index"

  resources :projects
  get 'my_projects', to: 'projects#my_projects'

  get 'indexes', to: 'indexes#index'
  get 'indexes/terms'
  get 'indexes/contributors'
  get 'indexes/places'

end
