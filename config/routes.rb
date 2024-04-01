Rails.application.routes.draw do
  # start jiinda method routes
  jinda_methods = ['pending', 'status', 'search', 'doc', 'doc_print', 'logs', 'ajax_notice']
  jinda_methods += ['init', 'run', 'run_mail', 'document', 'run_do', 'run_form', 'end_form']
  jinda_methods += ['run_redirect', 'run_direct_to','run_if']
  jinda_methods += ['error_logs', 'notice_logs', 'cancel', 'run_output', 'end_output']
  jinda_methods.each do |aktion| get "/jinda/#{aktion}" => "jinda##{aktion}" end
  
  # Define the actions array
  jinda_actions = ['init', 'pending', 'end_form', 'end_output']
  # Generate routes for each action
  jinda_actions.each do |action|
   post "/jinda/#{action}" => "jinda##{action}"
  end
  
  # end jinda method routes
  post '/auth/:provider/callback' => 'sessions#create'
  get '/auth/:provider/callback' => 'sessions#create'
  get '/auth/failure' => 'sessions#failure'
  get '/logout' => 'sessions#destroy', :as => 'logout'


  # Define the actions array
  actions = ['my', 'destroy', 'show', 'edit']

  # Define modules and generate routes for each module and action
  ['articles', 'jobs', 'docs', 'notes'].each do |module_name|
    actions.each do |action|
      get "/#{module_name}/#{action}" => "#{module_name}##{action}"
      get "/#{module_name}/my/destroy" => "#{module_name}#destroy"
      get "/#{module_name}/my/destroy/:id" => "#{module_name}#destroy"
    end
  end

  resources :articles do resources :comments end
  resources :jobs
  resources :comments
  resources :notes
  resources :docs
  resources :users
  resources :identities
  resources :sessions
  resources :password_resets
  resources :jinda, :only => [:index, :new]
  get '/jinda/document/:id' => 'jinda#document'
  # root :to => 'jinda#index'
  # api
  get '/api/v1/notes/my' => 'api/v1/notes#my'
  post '/api/v1/notes' => 'api/v1/notes#create', as: 'api_v1_notes'
  namespace :api do
  namespace :v1 do resources :notes, :only => [:index] end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
# Define Routes constant
# Routes = Rails.application.routes
