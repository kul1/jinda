Jinda::Engine.routes.draw do
  resources :articles do
    resources :comments
  end
  root to: 'articles#index'

  # start jiinda method routes
  jinda_methods = ['pending', 'status', 'search', 'doc', 'doc_print', 'logs', 'ajax_notice']
  jinda_methods += ['init', 'run', 'run_mail', 'document', 'run_do', 'run_form', 'end_form']
  jinda_methods += ['run_redirect', 'run_direct_to','run_if']
  jinda_methods += ['error_logs', 'notice_logs', 'cancel', 'run_output', 'end_output']
  jinda_methods.each do |aktion| get "/jinda/#{aktion}" => "jinda##{aktion}" end
  post '/jinda/init' => 'jinda#init'
  post '/jinda/pending' => 'jinda#index'
  post '/jinda/end_form' => 'jinda#end_form'
  post '/jinda/end_output' => 'jinda#end_output'
  # end jinda method routes
end
