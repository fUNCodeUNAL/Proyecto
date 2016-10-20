Rails.application.routes.draw do
  get 'submission/new'

  root 'pages#index'
  get 'pages/index'

  devise_for :users, :controllers => { registrations: 'registrations' }

  get 'pages/ok', as: "ok"
  get 'pages/wrong'

  get 'profile/:username', to: 'pages#profile', as: "profile"
  
  get 'teacher/show/groups', to: 'teacher#show_groups', as: "teacher_groups_show"
  post 'teacher/show/groups/create', to: 'group#create', as: "teacher_groups_create"
  delete 'teacher/show/groups/:id', to: 'group#destroy', as: "teacher_groups_delete"  

  get 'groups/edit/:id_group', to: 'group#edit', as: "teacher_groups_edit"
  post 'groups/edit', to: 'group#add_student', as: "group_add_student"
  delete 'groups/delete/:id_group/:id_student', to: 'group#delete_student', as: "group_student_delete"

  get 'problem/index', to: 'problem#index', as: "problem_index"
  get 'problem/new', to: 'problem#new', as: "problem_new"
  get 'problem/:id', to: 'problem#show', as: "problem"
  post 'problem/create', to: 'problem#create', as: "problem_create"
  get 'problem/edit/:id', to: 'problem#edit', as: "problem_edit"
  put 'problem/update/:id', to: 'problem#update', as: "problem_update"

  get 'search', to: 'pages#search', as: "search"

  #Modificar primary key, en caso de implementar metodos

  get 'problem/:problem_id/submission/new', to: 'submission#new', as: "submissions_new"
  get 'problem/:problem_id/:username/submission/', to: 'submission#showProblemUser', as: "submissions_problem_user"
  get 'problem/:problem_id/submission/', to: 'submission#showProblem', as: "submissions_problem"
  get ':username/submission/', to: 'submission#showUser', as: "submissions_user"
  post 'problem/:problem_id/submission/create', to: 'submission#create', as: "submissions_create"
  delete 'problem/:problem_id/testcase/delete/:test_idx', to: 'problem#delete_test_case', as: "problem_delete_test_case"
   #Para cuando vayamos a recalificar
   #put 'submission/update/:id', to: 'submission#update', as: "submission_update"


  get 'problem/:problem_id/testcase/:test_idx', to: 'test_case#show_test_case', as: "problem_show_test_case"
  put 'problem/:problem_id/testcase/update/:test_idx', to: 'test_case#edit', as: "problem_edit_test_case"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
