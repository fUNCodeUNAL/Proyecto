Rails.application.routes.draw do
  root 'pages#index'
  get 'pages/index'

  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :user, only: [:new, :create], param: :email

  get 'pages/ok'
  get 'pages/wrong'

  get 'profile/:id', to: 'pages#profile'
  get 'teacher/:id', to: 'teacher#show_groups'

  post 'teacher/groups/new', to: 'group#new'
  post 'teacher/groups', to: 'group#create'
  delete 'teacher/groups/:id', to: 'group#destroy'

  #Modificar primary kay, en caso de implementar metodos

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
