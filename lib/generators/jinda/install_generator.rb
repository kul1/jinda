module Jinda
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install jinda component to existing Rails app "
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end
      def setup_gems
        # define required gems: jinda_gem, jinda_dev_gem
        jinda_gem = 
          [
            ["bson", "4.4.2"],
            ["maruku", "~> 0.7.3"],
            ["bcrypt"],
            ["rouge"],
            ["normalize-rails"],
            ["font-awesome-rails"],
            ["font-awesome-sass", "~> 5.12.0"],
            ["meta-tags"],
            ["jquery-turbolinks", "2.1.0"],
            ["mongo", "2.11.3"],
            ["turbolinks_render"],
            ["haml-rails", "~> 2.0.1"],
            ["haml", "~> 5.1", ">= 5.1.2"],
            ["mail"],
            ["prawn"],
            ["redcarpet"],
            ["oauth2", "1.4.4"],
            ["omniauth", "1.9.1"],
            ["omniauth-oauth2", "1.6.0"],
            ["omniauth-identity", "~> 1.1.1"],
            ["omniauth-facebook", "6.0.0"],
            ["omniauth-google-oauth2", "0.8.0"],
            ["dotenv-rails"],
            ["cloudinary", "1.13.2"],
            ["kaminari", "1.2.0"],
            ["jquery-rails", "4.3.5"]
        ]

        jinda_custom = 
          [
            ["mongoid-paperclip", require: "mongoid_paperclip"],
            ["kaminari-mongoid", "1.0.1"],
            ["nokogiri", "~> 1.11.0"],
            ["mongoid", git: "git@github.com:kul1/mongoid.git"]
          ]

        jinda_dev_gem =
          [
            ["shoulda"],
            ["rspec"],
            ["rspec-rails"],
            ["better_errors"],
            ["binding_of_caller"],
            ["pry-byebug"],
            ["factory_bot_rails"],
            ["database_cleaner"],
            ["guard"],
            ["guard-rspec"],
            ["guard-minitest"],
            ["capybara"],
            ["selenium-webdriver"],
            ["rb-fsevent"],
            ["valid_attribute"],
            ["faker"]
          ]

        # Check each jinda_gem and create new array if found one otherwise just create.
        # Open Gemfile add gem if not exist
        jinda_gem.each do |g|
          unless (%x(gem list -e --no-versions #{g[0]})) == "#{g[0]}\n"
            if g.count == 2
                gem g[0], g[1]
            else
              gem g[0]
            end
          else
            if g.count == 2
              xgem_0 = %x(gem list -e #{g[0]})
              unless xgem_0.include?(("#{g[1]}").gsub(/[~> ]/, ''))
                say "    Found existing #{xgem_0} in Gemfile or System, Please edit Gemfile", :red
                gem g[0], g[1]
              else  
                say "     Checking #{g[0]} found Ver. #{g[1]} already exist in Gemfile", :green
              end 
            end
            say "     SKIP adding #{g[0]} in Gemfile", :yellow
          end
        end

        # create list of gem in sub-group dev and test
        jinda_dev_new  = Array.new
        jinda_dev_gem.each do |g|
          unless (%x(gem list -e --no-versions #{g[0]})) == "#{g[0]}\n"
            jinda_dev_new << g
          else
            say "     #{g[0]} already exist in Gemfile", :yellow
          end
        end
        unless jinda_dev_new.count == 0
          gem_group :development, :test do
            jinda_dev_new.each do |n|
              if n.count == 1
                gem n[0]
              else
                gem n[0], n[1]
              end
            end
          end
        end

        # create list of custom gem
        jinda_custom_new = Array.new
        jinda_custom.each do |g|
          unless (%x(gem list -e --no-versions #{g[0]})) == "#{g[0]}\n"
            jinda_custom_new << g
          else
            say "     #{g[0]} already exist in Gemfile", :yellow
          end
        end
        unless jinda_custom_new.count == 0
            jinda_custom_new.each do |c|
            say "     Checking if #{c[0]} already exist in Gemfile", :yellow
              if c.count == 1
                gem c[0]
              else
                gem c[0], c[1]
              end
            end
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
        inside("config/initializers") {(File.file? "mongoid.rb") ? (FileUtils.mv 'mongoid.rb', 'mongoid.rb.bak') : (say "no mongoid.rb")}
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
        inside("app/controllers") {(File.file? "admins_controller.rb") ? ( say "   Please merge existing jinda_org/admins_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/admins_controller.rb', 'admins_controller.rb')}
        inside("app/controllers") {(File.file? "articles_controller.rb") ? ( say "   Please merge existing jinda_org/articles_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/articles_controller.rb', 'articles_controller.rb')}
        inside("app/controllers") {(File.file? "comments_controller.rb") ? ( say "   Please merge existing jinda_org/comments_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/comments_controller.rb', 'comments_controller.rb')}
        inside("app/controllers") {(File.file? "docs_controller.rb") ? ( say "   Please merge existing jinda_org/docs_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/docs_controller.rb', 'docs_controller.rb')}
        inside("app/controllers") {(File.file? "identities_controller.rb") ? ( say "   Please merge existing jinda_org/identities_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/identities_controller.rb', 'identities_controller.rb')}
        inside("app/controllers") {(File.file? "application_controller.rb") ? ( say "   Pleas merge existing jinda_org/application_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/application_controller.rb', 'application_controller.rb')}
        ## Moved to Engine
        # inside("app/controllers") {(File.file? "jinda_controller.rb") ? ( say "   Please merge existing jinda_org/jinda_controller.rb after this installation", :red) : (FileUtils.mv 'jinda_org/jinda_controller.rb', 'jinda_controller.rb')}
        inside("app/controllers") {(File.file? "password_resets_controller.rb") ? ( say "   Please merge existing jinda_org/password_resets_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/password_resets_controller.rb', 'password_resets_controller.rb')}
        inside("app/controllers") {(File.file? "password_resets.rb") ? ( say "   Please merge existing jinda_org/password_resets.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/password_resets.rb', 'password_resets.rb')}
        inside("app/controllers") {(File.file? "sessions_controller.rb") ? ( say "   Please merge existing jinda_org/sessions_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/sessions_controller.rb', 'sessions_controller.rb')}
        inside("app/controllers") {(File.file? "users_controller.rb") ? ( say "   Please merge existing jinda_org/users_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/users_controller.rb', 'users_controller.rb')}
        inside("app/controllers") {(File.file? "sitemap_controller.rb") ? ( say "   Please merge existing jinda_org/sitemap_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/sitemap_controller.rb', 'sitemap_controller.rb')}
        inside("app/controllers") {(File.file? "notes_controller.rb") ? ( say "   Please merge existing jinda_org/notes_controller.rb after this installation", :yellow) : (FileUtils.mv 'jinda_org/notes_controller.rb', 'notes_controller.rb')}
      end
      # routes created each line as reversed order in routes
      # Moved routes to Engine
      def setup_routes
        route "root :to => 'jinda#index'"        
      end

      def setup_env
        FileUtils.mv "README.md", "README.md.bak"
        create_file 'README.md', ''
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
        # Move mongoid.rb to jinda:config
        # To avoid repeate install jinda:install crash
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
          "\n  config.assets.check_precompiled_asset = false"
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
