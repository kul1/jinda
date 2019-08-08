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
        gem 'font-awesome-sass', '~> 4.7.0'
        gem 'ckeditor', github: 'galetahub/ckeditor'

        gem 'mongoid-paperclip', require: 'mongoid_paperclip'
        gem 'meta-tags'
        gem 'jquery-turbolinks'
        gem 'mongo', '~> 2.2'
        gem 'bson', '~> 4.0'
        gem 'mongoid', '6.1.0'
        gem 'nokogiri' # use for jinda/doc
        gem 'haml', git: 'https://github.com/haml/haml'
        gem 'haml-rails'
        gem 'mail'
        gem 'prawn'
        gem 'redcarpet'
        gem 'bcrypt'
        gem 'omniauth-identity'
        gem 'omniauth-facebook'
	    gem 'omniauth-google-oauth2'
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
          inside("db") {(File.file? "seeds.rb") ? (FileUtils.mv "seeds.rb", "seeds.rb.bak") : ( puts "no seeds.rb")}
        inside("app/views/layouts") {(File.file? "application.html.erb") ? (FileUtils.mv 'application.html.erb', 'application.html.erb.bak') : ( puts "no app/views/layout/ application.html.erb")}
        inside("app/controllers") {(File.file? "application_controller.rb") ? (FileUtils.mv 'application_controller.rb', 'application_controller.rb.bak' ) : ( puts "no app/controller/application_controller.rb")}
        inside("app/helpers") {(File.file? "application_helper.rb") ? (FileUtils.mv 'application_helper.rb', 'application_helper.rb.bak') : ( puts "no app/helpers/application_helper.rb")}
        inside("app/assets/javascripts") {(File.file? "javascripts.js") ? (FileUtils.mv 'javascripts.js', 'javascripts.js.bak') : ( puts "no javascript.js")}
        inside("app/assets/stylesheets") {(File.file? "javascripts.css") ? (FileUtils.mv 'javascripts.css', 'javascripts.css.bak') : ( puts "no javascript.css")}
        inside("config/initializers") {(File.file? "omniauth.rb") ? (FileUtils.mv 'omniauth.rb', 'omniauth.rb.bak') : (puts "no omniauth.rb")}
        # inside("config/initializers") {(File.file? "mongoid.rb") ? (FileUtils.mv 'mongoid.rb', 'mongoid.rb.bak') : (puts "no mongoid.rb")}
        # inside("config/initializers") {(File.file? "ckeditor.rb") ? (FileUtils.mv 'ckeditor.rb ckeditor.rb.bak') : (puts "no ckeditor.rb ")}
        directory "app"
        directory "spec"
        directory "db"
        directory "config"
        directory "dot"
      end
      # routes created each line as reversed order button up in routes
      def setup_routes
        route "root :to => 'jinda#index'"        
        route "resources :jinda, :only => [:index, :new]"
        route "resources :password_resets"
        route "resources :sessions"
        route "resources :identities"
        route "resources :users"
        route "resources :articles"
		route "get '/articles/my/destroy' => 'articles#destroy'"
        route "get '/articles/my' => 'articles/my'"
        route "get '/logout' => 'sessions#destroy', :as => 'logout'"
        route "get '/auth/:provider/callback' => 'sessions#create'"
        route "post '/auth/:provider/callback' => 'sessions#create'"        
		route "\# end jinda method routes"
        route "mount Ckeditor::Engine => '/ckeditor'"
        route "post '/jinda/end_form' => 'jinda#end_form'"
        route "post '/jinda/pending' => 'jinda#index'"
        route "post '/jinda/init' => 'jinda#init'"
        route "jinda_methods.each do \|aktion\| get \"/jinda/\#\{aktion\}\" => \"jinda#\#\{aktion\}\" end"
        route "jinda_methods += ['init','run','run_do','run_form','end_form','error_logs', 'notice_logs', 'cancel']"
        route "jinda_methods = ['pending','status','search','doc','logs','ajax_notice']"  
        route "\# start jiinda method routes"
	  end

      def setup_env
        FileUtils.mv "README.md", "README.md.bak"
        create_file 'README.md', ''
        # FileUtils.mv 'install.sh', 'install.sh'
        inject_into_file 'config/application.rb', :after => 'require "active_resource/railtie"' do
          "\nrequire 'mongoid/railtie'\n"
          "\nrequire 'rexml/document'\n"
        end
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
  config.time_zone = "Central Time (US & Canada)"

  # gmail config
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :user_name            => 'user@gmail.com',
    :password             => 'secret',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true
}
        end
        initializer "jinda.rb" do
%q{# encoding: utf-8
MM = "#{Rails.root}/app/jinda/index.mm"
DEFAULT_TITLE = 'Jinda'
DEFAULT_HEADER = 'Jinda'
DEFAULT_DESCRIPTION = 'Rails Application Generator'
DEFAULT_KEYWORDS = %w[Jinda Rails ruby Generator]
GMAP = false
ADSENSE = true
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
      def gen_user
        # FileUtils.cp "db/seeds.rb","db/seeds.rb"
      end


      def finish
        puts "\n"
        puts "Jinda gem ready for next configuration install.\n"
        puts "    (or short cut with sh install.sh)\n" 
        puts "Normally you will use  the following command:\n"
        puts "----------------------------------------\n"
        puts "bundle install\n"
        puts "rails generate jinda:config\n"
        puts "rake jinda:seed\n"
        puts 
        puts "----------------------------------------\n"
      end
    end
  end
end
