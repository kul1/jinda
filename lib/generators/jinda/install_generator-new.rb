module Jinda
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install jinda component to existing Rails app"

      def self.source_root
        File.join(File.dirname(__FILE__), "templates")
      end

      def setup_gems
        gems_setup
      end

      def setup_app
        app_setup
      end

      def setup_routes
        route_setup
      end

      def setup_env
        env_setup
      end

      private 

      def gems_setup
        add_or_skip_gems(jinda_gem)
        add_or_skip_gems(jinda_dev_gem, :development, :test)
        add_or_skip_gems(jinda_custom)
      end

      def add_or_skip_gems(gems, *groups)
        gems_to_add = []
        gems.each do |g|
          unless gem_exists?(g[0])
            gems_to_add << g
          else
            say "     #{g[0]} already exist in Gemfile", :yellow
          end
        end
        add_gems(gems_to_add, *groups) unless gems_to_add.empty?
      end

      def gem_exists?(gem_name)
        (%x(gem list -e --no-versions #{gem_name})).strip == gem_name
      end

      def add_gems(gems, *groups)
        if groups.empty?
          gems.each { |g| add_gem(g) }
        else
          gem_group(*groups) do
            gems.each { |g| add_gem(g) }
          end
        end
      end

      def add_gem(g)
        if g.count == 1
          gem g[0]
        else
          gem g[0], g[1]
        end
      end

      def app_setup
        backup_existing_files
        move_files_from_jinda_org
        create_directories
      end

      def backup_existing_files
        file_operations = {
          'db' => 'seeds.rb',
          'app/views/layouts' => 'application.html.erb',
          'app/controllers' => 'application_controller.rb',
          'app/helpers' => 'application_helper.rb',
          'app/assets/javascripts' => 'application.js',
          'app/assets/stylesheets' => 'application.css',
          'config/initializers' => ['omniauth.rb', 'mongoid.rb'],
          'app/assets/config' => 'manifest.js'
        }
      
        file_operations.each do |dir, files|
          [files].flatten.each do |file|
            inside(dir) do
              if File.file?(file)
                FileUtils.mv file, "#{file}.bak"
              else
                say "no #{file}", :blue
              end
            end
          end
        end
      end
      
      def move_files_from_jinda_org
        files = %w[
          admins_controller.rb articles_controller.rb comments_controller.rb
          docs_controller.rb identities_controller.rb application_controller.rb
          password_resets_controller.rb password_resets.rb sessions_controller.rb
          users_controller.rb sitemap_controller.rb notes_controller.rb
        ]
      
        files.each do |file|
          inside("app/controllers") do
            if File.file?(file)
              say "   Please merge existing jinda_org/#{file} after this installation", :yellow
            else
              FileUtils.mv "jinda_org/#{file}", file
            end
          end
        end
      end
      
      def create_directories
        %w[app spec db config dot].each do |dir|
          directory dir
        end
      end

      def route_setup
        route "root :to => 'jinda#index'"        
      end

      def env_setup
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
      def jinda_gem
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
            ["jquery-rails", "4.3.5"],
            ["mongoid"],
            ["rexml", "~> 3.2.4"]
        ]
      end
      
      def jinda_custom
        jinda_custom = 
          [
            ["mongoid-paperclip", require: "mongoid_paperclip"],
            ["kaminari-mongoid", "1.0.1"],
            ["nokogiri", "~> 1.11.0"]
          ]
      end

      def jinda_dev_gem
        jinda_dev_gem =
          [
            ["shoulda"],
            ["rspec"],
            ["rspec-rails"],
            ["better_errors"],
            ["binding_of_caller"],
            ["pry-byebug"],
            ["factory_bot_rails"],
            ["database_cleaner-mongoid"],
            ["guard"],
            ["guard-rspec"],
            ["guard-minitest"],
            ["capybara"],
            ["selenium-webdriver"],
            ["rb-fsevent"],
            ["valid_attribute"],
            ["faker"]
          ]
      end

    end
  end
end

