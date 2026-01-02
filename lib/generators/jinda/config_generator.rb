# frozen_string_literal: true

module Jinda
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      def self.source_root
        "#{File.dirname(__FILE__)}/templates"
      end
      desc 'Backup Files'
      def backup_files
        # inside("config/initializers") {(File.file? "omniauth.rb") ? (FileUtils.mv "omniauth.rb",  "omniauth.rb.bak") : (puts "new omniauth.rb created")}
        # inside("config/initializers") {(File.file? "mongoid.rb") ? (FileUtils.mv "mongoid.rb", "omniauth.rb.bak") : (puts "new mongoid.rb created")}
        File.file?('.env') ? (FileUtils.mv '.env', '.env-bak') : (Rails.logger.debug 'backup .env')
      end
      desc 'gen_image_store'
      def gen_image_store
        # FileUtils.cp "cloudinary.yml","config/cloudinary.yml"
        # FileUtils.cp "dot.env",".env"
        # FileUtils.cp "dot.rspec",".rspec"
        empty_directory 'upload' # create upload directory just in case
      end
      desc 'Set up omniauth config'
      def setup_omniauth
        # gem 'bcrypt-ruby', '~> 3.0.0'
        # gem 'omniauth-identity'
        initializer 'omniauth.rb' do
          "
                    Rails.application.config.middleware.use OmniAuth::Builder do
                      provider :identity,
                               :fields => [:code, :email],
                               :on_failed_registration=> lambda { |env|
                                 IdentitiesController.action(:new).call(env)
                               }
                      provider :facebook, ENV['FACEBOOK_API'], ENV['FACEBOOK_KEY']
                      provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], skip_jwt: true
                    end

                    # Allow both POST and GET requests for OmniAuth (Rails 7 compatibility)
                    OmniAuth.config.allowed_request_methods = [:post, :get]

                    # https://stackoverflow.com/questions/11461084/handle-omniautherror-invalid-credentials-for-identity-login
                    OmniAuth.config.on_failure = Proc.new { |env|
                      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
                    }

                  "
        end
      end

      desc 'Set up mongoid config'
      def setup_mongoid
        generate 'mongoid:config -f'
        inject_into_file 'config/mongoid.yml', after: '  # raise_not_found_error: true' do
          "\n    raise_not_found_error: false"
        end

        inject_into_file 'config/mongoid.yml', after: '  # belongs_to_required_by_default: true' do
          "\n    belongs_to_required_by_default: false"
        end
        inject_into_file 'config/mongoid.yml', after: '  # app_name: MyApplicationName' do
          "\n\nproduction:" \
            "\n  clients:" \
            "\n    default:" \
            "\n      uri: <%= ENV['MONGODB_URI'] %>" \
            "\n  options:" \
            "\n    raise_not_found_error: false" \
            "\n    belongs_to_required_by_default: false\n"
        end
      end

      desc 'Setup Dockerfile'
      def setup_docker
        Rails.logger.debug '      Setup Docker files'
        FileUtils.cp "#{source_paths[0]}/Dockerfile", 'Dockerfile'
        FileUtils.cp "#{source_paths[0]}/docker-compose.yml", 'docker-compose.yml'
        FileUtils.cp "#{source_paths[0]}/docker-compose-mongodb.yml", 'docker-compose-mongodb.yml'
        FileUtils.cp "#{source_paths[0]}/entrypoint.sh", 'entrypoint.sh'
      end

      def finish
        Rails.logger.debug "      configured omniauth.\n"
        Rails.logger.debug "      configured Mongoid.\n"
        Rails.logger.debug "\n"
        Rails.logger.debug "      To set user/password as admin/secret run:\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug "rails jinda:seed\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug '      Docker options:'
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug "Full stack: docker compose up -d\n"
        Rails.logger.debug "MongoDB only: docker compose -f docker-compose-mongodb.yml up -d\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug '      To test with rspec  run:'
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug "rspec\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug '      To config rspec run:'
        Rails.logger.debug "rails g jinda:rspec\n"
        Rails.logger.debug "run $chromediver for Capybara & Chrome\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug '      To config minitest run:'
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug "rails g jinda:minitest\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug '      To login with facebook'
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug "Please config. in .env or restore from .env-bak \n"
        Rails.logger.debug "-----------------------------------------\n"
      end
    end
  end
end
