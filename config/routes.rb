Rails.application.routes.draw do
  root 'pages#index'
  get 'pages/index'
  devise_for :users, :controllers => { registrations: 'registrations' }
  resources :user, only: [:new, :create], param: :email


  #Modificar primary kay, en caso de implementar metodos

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
