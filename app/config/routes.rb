# frozen_string_literal: true

Rails.application.routes.draw do
  # start jiinda method routes
  jinda_methods  = %w[pending status search doc doc_print logs ajax_notice]
  jinda_methods += %w[init run run_mail document run_do run_form end_form]
  jinda_methods += %w[run_redirect run_direct_to run_if]
  jinda_methods += %w[error_logs notice_logs cancel run_output end_output]
  jinda_methods.each do |aktion|
    get "/jinda/#{aktion}" => "jinda##{aktion}"
  end
  post "/jinda/init" => "jinda#init"
  post "/jinda/pending" => "jinda#index"
  post "/jinda/end_form" => "jinda#end_form"
  post "/jinda/end_output" => "jinda#end_output"
  # end jinda method routes
  post "/auth/:provider/callback" => "sessions#create"
  get "/auth/:provider/callback" => "sessions#create"
  get "/auth/failure" => "sessions#failure"
  get "/logout" => "sessions#destroy", :as => "logout"
  get "/articles/my" => "articles#my"
  get "/articles/my/destroy" => "articles#destroy"
  get "/articles/show" => "articles/show"
  get "/articles/edit" => "articles/edit"
  get "/docs/my" => "docs/my"
  get "/notes/my" => "notes/my"
  get "/docs/my/destroy" => "docs#destroy"
  get "/notes/my/destroy/:id" => "notes#destroy"
  get "/notes/destroy/:id" => "notes#destroy"
  get "/jinda/document/:id" => "jinda#document"
  resources :articles do
    resources :comments
  end
  resources :comments
  resources :notes
  resources :docs
  resources :users
  resources :identities
  resources :sessions
  resources :password_resets
  resources :jinda, only: %i[index new]
  # root :to => 'jinda#index'
  # api
  get "/api/v1/notes/my" => "api/v1/notes#my"
  post "/api/v1/notes" => "api/v1/notes#create", as: "api_v1_notes"
  namespace :api do
    namespace :v1 do
      resources :notes, only: [:index]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
# Define Routes constant
Routes = Rails.application.routes
