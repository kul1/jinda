module Jinda
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install jinda component to existing Rails app "
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end

      def setup_gems
        gem 'maruku', '~> 0.7.3'
        gem 'rouge'
        gem 'normalize-rails'
        gem 'font-awesome-rails'
        gem 'font-awesome-sass', '~> 5.12.0'
        gem 'ckeditor', github: 'galetahub/ckeditor'
        gem 'mongoid-paperclip', require: 'mongoid_paperclip'
        gem 'meta-tags'
        gem 'jquery-turbolinks'
        gem 'mongo', '~> 2.7.0'
        gem 'bson', '~> 4.0'
        gem 'mongoid', '>= 6.0'
        gem 'turbolinks_render'
        gem 'nokogiri' # use for jinda/doc
        gem 'haml', '~> 5.1', '>= 5.1.2'
        gem 'haml-rails', '~> 1.0'
        gem 'mail'
        gem 'prawn'
        gem 'redcarpet'
        gem 'bcrypt'
        gem 'omniauth', '~> 1.8.1'
        gem 'omniauth-identity', '~> 1.1.1'
        gem 'omniauth-facebook', '~> 5.0.0'
        gem 'omniauth-google-oauth2', '~> 0.5.3'
        gem 'omniauth-rails_csrf_protection'
        gem 'dotenv-rails'
        gem 'cloudinary'
        gem 'kaminari'
        gem 'kaminari-mongoid'
        gem 'jquery-rails'
        gem_group :development, :test do
          gem 'rspec'
          gem 'rspec-rails'
          gem 'better_errors'
          gem 'binding_of_caller'
          gem 'pry-byebug'
          gem 'factory_bot_rails'
		      gem 'database_cleaner'
          gem 'guard'
          gem 'guard-rspec'
          gem 'guard-minitest'
          gem 'capybara'
		      gem 'selenium-webdriver'
          gem 'rb-fsevent'
		      gem 'valid_attribute'
          gem 'faker', :git => 'https://github.com/stympy/faker.git', :branch => 'master'
        end
      end

      def setup_app
        # inside("public") { run "FileUtils.mv index.html index.html.bak" }
          inside("db") {(File.file? "seeds.rb") ? (FileUtils.mv "seeds.rb", "seeds.rb.bak") : ( say "no seeds.rb", :green)}
        inside("app/views/layouts") {(File.file? "application.html.erb") ? (FileUtils.mv 'application.html.erb', 'application.html.erb.bak') : ( say "no app/views/layout/ application.html.erb", :blue )}
        inside("app/controllers") {(File.file? "application_controller.rb") ? (FileUtils.mv 'application_controller.rb', 'application_controller.rb.bak' ) : ( say "no app/controller/application_controller.rb, :blue ")}
        inside("app/helpers") {(File.file? "application_helper.rb") ? (FileUtils.mv 'application_helper.rb', 'application_helper.rb.bak') : ( say "no app/helpers/application_helper.rb", :blue)}
        inside("app/assets/javascripts") {(File.file? 'application.js') ? (FileUtils.mv 'application.js', 'application.js.bak') : ( say "no application.js", :blue)}
        inside("app/assets/stylesheets") {(File.file? "application.css") ? (FileUtils.mv 'application.css', 'application.css.bak') : ( say "no application.css", :blue)}
        inside("config/initializers") {(File.file? "omniauth.rb") ? (FileUtils.mv 'omniauth.rb', 'omniauth.rb.bak') : (say "no omniauth.rb", :blue)}
        # inside("config/initializers") {(File.file? "mongoid.rb") ? (FileUtils.mv 'mongoid.rb', 'mongoid.rb.bak') : (say "no mongoid.rb")}
        # inside("config/initializers") {(File.file? "ckeditor.rb") ? (FileUtils.mv 'ckeditor.rb ckeditor.rb.bak') : (say "no ckeditor.rb ")}
        inside("app/assets/config") {(File.file? "manifest.js") ? (FileUtils.mv "manifest.js", "manifest.js-rails") : (puts "backup to manifest.js-rails")}
        directory "app"
        directory "spec"
        directory "db"
        directory "config"
        directory "dot"
        # 
        # CHECK IF EXISTING CODE THEN REQUIRED MANUAL MIGRATION
        # If no javascripts.js or css (New application), then can use javascript.js or css from org files.
        # inside("app/assets/javascripts") {(File.file? "application.js") ? ( say "Please include application-org.js in application.js", :red) : (FileUtils.mv 'application-org.js', 'application.js')}
        # inside("app/assets/stylesheets") {(File.file? "application.css") ? ( say "Please include application-org.css in application.css", :red) : (FileUtils.mv 'application-org.css', 'application.css')}
        # inside("app/assets/stylesheets") {(File.file? "application.css.scss") ? ( say "Please include application-org.css.scss in application.css.scss", :red) : (FileUtils.mv 'application-org.css.scss', 'application.css.scss')}
        inside("app/controllers") {(File.file? "application_controller.rb") ? ( say "Pleas merge existing jinda_org/application_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/application_controller.rb', 'application_controller.rb')}
        inside("app/controllers") {(File.file? "admins_controller.rb") ? ( say "Please merge existing jinda_org/admins_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/admins_controller.rb', 'admins_controller.rb')}
        inside("app/controllers") {(File.file? "articles_controller.rb") ? ( say "Please merge existing jinda_org/articles_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/articles_controller.rb', 'articles_controller.rb')}
        inside("app/controllers") {(File.file? "comments_controller.rb") ? ( say "Please merge existing jinda_org/comments_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/comments_controller.rb', 'comments_controller.rb')}
        inside("app/controllers") {(File.file? "identities_controller.rb") ? ( say "Please merge existing jinda_org/identities_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/identities_controller.rb', 'identities_controller.rb')}
        inside("app/controllers") {(File.file? "jinda_controller.rb") ? ( say "Please merge existing jinda_org/jinda_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/jinda_controller.rb', 'jinda_controller.rb')}
        inside("app/controllers") {(File.file? "password_resets_controller.rb") ? ( say "Please merge existing jinda_org/password_resets_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/password_resets_controller.rb', 'password_resets_controller.rb')}
        inside("app/controllers") {(File.file? "password_resets.rb") ? ( say "Please merge existing jinda_org/password_resets.rb after this installation", :red) : (FileUtils.mv 'jinda_org/password_resets.rb', 'password_resets.rb')}
        inside("app/controllers") {(File.file? "sessions_controller.rb") ? ( say "Please merge existing jinda_org/sessions_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/sessions_controller.rb', 'sessions_controller.rb')}
        inside("app/controllers") {(File.file? "users_controller.rb") ? ( say "Please merge existing jinda_org/users_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/users_controller.rb', 'users_controller.rb')}
        inside("app/controllers") {(File.file? "sitemap_controller.rb") ? ( say "Please merge existing jinda_org/sitemap_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/sitemap_controller.rb', 'sitemap_controller.rb')}
        inside("app/controllers") {(File.file? "notes_controller.rb") ? ( say "Please merge existing jinda_org/notes_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/notes_controller.rb', 'notes_controller.rb')}
      end
      # routes created each line as reversed order button up in routes
      def setup_routes
        route "end"
        route "  end"
        route "    namespace :v1 do resources :notes, :only => [:index] end"
        route "  namespace :api do"
        route "post '/api/v1/notes' => 'api/v1/notes#create', as: 'api_v1_notes'" 
        route "get '/api/v1/notes/my' => 'api/v1/notes#my'"
        route "\# api"
        route "root :to => 'jinda#index'"        
        route "resources :jinda, :only => [:index, :new]"
        route "resources :password_resets"
        route "resources :sessions"
        route "resources :identities"
        route "resources :users"
        route "resources :notes"
        route "resources :articles"
        route "get '/notes/destroy/:id' => 'notes#destroy'"
        route "get '/notes/my/destroy/:id' => 'notes#destroy'"
        route "get '/notes/my' => 'notes/my'"
		    route "get '/articles/my/destroy' => 'articles#destroy'"
        route "get '/articles/my' => 'articles/my'"
        route "get '/logout' => 'sessions#destroy', :as => 'logout'"
        route "get '/auth/failure' => 'sessions#destroy'"
        route "get '/auth/:provider/callback' => 'sessions#create'"
        route "post '/auth/:provider/callback' => 'sessions#create'"        
		    route "\# end jinda method routes"
        route "mount Ckeditor::Engine => '/ckeditor'"
        route "post '/jinda/end_form' => 'jinda#end_form'"
        route "post '/jinda/pending' => 'jinda#index'"
        route "post '/jinda/init' => 'jinda#init'"
        route "jinda_methods.each do \|aktion\| get \"/jinda/\#\{aktion\}\" => \"jinda#\#\{aktion\}\" end"
        route "jinda_methods += ['init','run','run_mail','document','run_do','run_form','end_form','error_logs', 'notice_logs', 'cancel']"
        route "jinda_methods = ['pending','status','search','doc','logs','ajax_notice']"  
        route "\# start jiinda method routes"
	  end

      def setup_env
        FileUtils.mv "README.md", "README.md.bak"
        create_file 'README.md', ''
        # FileUtils.mv 'install.sh', 'install.sh'
        # inject_into_file 'config/application.rb', :after => 'require "active_resource/railtie"' do
        # inject_into_file 'config/application.rb', :after => 'require "rails"' do
        #   "\nrequire 'rexml/document'\n"+
        #   "\nrequire 'mongoid/railtie'\n"
        # end
        application do
%q{
  # Jinda default
  config.generators do |g|
    g.orm             :mongoid
    g.template_engine :haml
    g.test_framework  :rspec
    g.integration_tool :rspec
  end

  # config time zone
  # config.time_zone = "Central Time (US & Canada)"

  # gmail config
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.smtp_settings = {
  #   :address              => "smtp.gmail.com",
  #   :port                 => 587,
  #   :user_name            => 'user@gmail.com',
  #   :password             => 'secret',
  #   :authentication       => 'plain',
  #   :enable_starttls_auto => true  }
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.perform_deliveries = true
}
        end
        initializer "jinda.rb" do
%q{# encoding: utf-8
MM = "#{Rails.root}/app/jinda/index.mm"
DEFAULT_TITLE = 'Jinda'
DEFAULT_HEADER = 'Jinda'
DEFAULT_DESCRIPTION = 'Rails Application Generator'
DEFAULT_KEYWORDS = %w[Jinda Rails ruby Generator, Prateep Kul]
GMAP = false
# ADSENSE = true
NEXT = "Next >"
# comment IMAGE_LOCATION to use cloudinary (specify params in config/cloudinary.yml)
IMAGE_LOCATION = "upload"
# for debugging
# DONT_SEND_MAIL = true
}
        end

initializer "mongoid.rb" do
%q{# encoding: utf-8
#
# Mongoid 6 follows the new pattern of AR5 requiring a belongs_to relation to always require its parent
# belongs_to` will now trigger a validation error by default if the association is not present.
# You can turn this off on a per-association basis with `optional: true`.
# (Note this new default only applies to new Rails apps that will be generated with
# `config.active_record.belongs_to_required_by_default = true` in initializer.)
#
Mongoid::Config.belongs_to_required_by_default = false
}
        end

        inject_into_file 'config/environment.rb', :after => "initialize!"  do
          "\n\n# hack to fix cloudinary error https://github.com/archiloque/rest-client/issues/141" +
          "\nclass Hash\n  remove_method :read\nrescue\nend"
        end
        inject_into_file 'config/environments/development.rb', :after => 'config.action_mailer.raise_delivery_errors = false' do
          "\n  config.action_mailer.default_url_options = { :host => 'localhost:3000' }"
        end
        inject_into_file 'config/environments/production.rb', :after => 'config.assets.compile = false' do
          "\n  config.assets.compile = true"
        end
        inject_into_file 'config/initializers/assets.rb', :after => '# Precompile additional assets.
' do        
"Rails.application.config.assets.precompile += %w( sarabun.css )" +
"\nRails.application.config.assets.precompile += %w( disable_enter_key.js )\n"
        end
      end

      def finish
        say "\n"
        say "Jinda gem ready for next configuration install.\n"
        say "    (or short cut with sh install.sh)\n" 
        say "Normally you will use  the following command:\n"
        say "----------------------------------------\n"
        say "bundle install\n"
        say "rails generate jinda:config\n"
        say "rake jinda:seed\n"
        say 
        say "----------------------------------------\n"
      end
    end
  end
end
