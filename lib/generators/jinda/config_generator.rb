module Jinda
    module Generators
        class ConfigGenerator < Rails::Generators::Base
            def self.source_root
                File.dirname(__FILE__) + "/templates"
            end
            desc "Backup Files"
            def backup_files
                st="      "
                # inside("config/initializers") {(File.file? "omniauth.rb") ? (FileUtils.mv "omniauth.rb",  "omniauth.rb.bak") : (puts "new omniauth.rb created")}
                # inside("config/initializers") {(File.file? "mongoid.rb") ? (FileUtils.mv "mongoid.rb", "omniauth.rb.bak") : (puts "new mongoid.rb created")}
                (File.file? ".env") ? (FileUtils.mv ".env", ".env-bak") : (puts "backup .env")
            end
            desc "gen_image_store"
            def gen_image_store
                # FileUtils.cp "cloudinary.yml","config/cloudinary.yml"
                # FileUtils.cp "dot.env",".env"
                # FileUtils.cp "dot.rspec",".rspec"
                empty_directory "upload" # create upload directory just in case
            end
            desc "Set up omniauth config"
            def setup_omniauth
                # gem 'bcrypt-ruby', '~> 3.0.0'
                # gem 'omniauth-identity'
                initializer "omniauth.rb" do
                  %q{
                    Rails.application.config.middleware.use OmniAuth::Builder do
                      provider :identity,
                               :fields => [:code, :email],
                               :on_failed_registration=> lambda { |env|
                                 IdentitiesController.action(:new).call(env)
                               }
                      provider :facebook, ENV['FACEBOOK_API'], ENV['FACEBOOK_KEY']
                      provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'], skip_jwt: true
                    end

                    # https://stackoverflow.com/questions/11461084/handle-omniautherror-invalid-credentials-for-identity-login
                    OmniAuth.config.on_failure = Proc.new { |env|
                      OmniAuth::FailureEndpoint.new(env).redirect_to_failure
                    }
                    
                  }
                end
            end


            desc "Set up mongoid config"
            def setup_mongoid
                generate "mongoid:config"
                inject_into_file 'config/mongoid.yml', :after => '  # raise_not_found_error: true' do
                    "\n    raise_not_found_error: false"
                end

                inject_into_file 'config/mongoid.yml', :after => '  # belongs_to_required_by_default: true' do
                    "\n    belongs_to_required_by_default: false"
                end
                inject_into_file 'config/mongoid.yml', :after => '  # app_name: MyApplicationName' do
                    "\n\nproduction:" +
                        "\n  clients:" +
                        "\n    default:" +
                        "\n      uri: <%= ENV['MONGODB_URI'] %>" +
                        "\n  options:" +
                        "\n    raise_not_found_error: false" +
                        "\n    belongs_to_required_by_default: false\n"
                end
            end

            def finish
                puts "      configured omniauth.\n"
                puts "      configured Mongoid.\n"
                puts "\n"
                puts "      To set user/password as admin/secret run:\n"
                puts "-----------------------------------------\n"
                puts "rails jinda:seed\n"
                puts "-----------------------------------------\n"
                puts "      To test with rspec  run:"
                puts "-----------------------------------------\n"
                puts "rspec\n"
                puts "-----------------------------------------\n"
                puts "      To config rspec run:"
                puts "rails g jinda:rspec\n"
                puts "run $chromediver for Capybara & Chrome\n"
                puts "-----------------------------------------\n"
                puts "      To config minitest run:"
                puts "-----------------------------------------\n"
                puts "rails g jinda:minitest\n"
                puts "-----------------------------------------\n"
                puts "      To login with facebook"
                puts "-----------------------------------------\n"
                puts "Please config. in .env or restore from .env-bak \n"
                puts "-----------------------------------------\n"
            end
        end
    end
end
