Rails.application.routes.draw do
  root 'pages#index'
  get 'pages/index'

  devise_for :users, :controllers => { registrations: 'registrations' }

  get 'pages/ok'
  get 'pages/wrong'

  get 'profile/:username', to: 'pages#profile', as: "profile"
  get 'teacher/:username', to: 'teacher#show_groups', as: "teacher_groups"

  post 'teacher/groups/new', to: 'group#new', as: "teacher_groups_new"
  post 'teacher/groups', to: 'group#create', as: "teacher_groups_create"
  delete 'teacher/groups/:id', to: 'group#destroy', as: "teacher_groups_delete"

  get 'groups/edit/:id_group', to: 'group#edit', as: "teacher_groups_edit"
  post 'groups/edit', to: 'group#add_student', as: "group_add_student"
  delete 'groups/delete/:id_group/:id_student', to: 'group#delete_student', as: "group_student_delete"

  #Modificar primary kay, en caso de implementar metodos

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
