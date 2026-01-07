Rails.application.routes.draw do
  get 'mindmap_editor/edit'
  post 'mindmap_editor/save'
  root :to => 'jinda#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get '/up' => 'rails/health#show', as: :rails_health_check

  # Suppress Chrome DevTools request
  get '/.well-known/appspecific/com.chrome.devtools.json', to: proc { [204, {}, ['']] }

  # Defines the root path route (/)
  # root posts#index
end
