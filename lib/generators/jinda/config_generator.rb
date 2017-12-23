module Jinda
  module Generators
    class ConfigGenerator < Rails::Generators::Base

      desc "Backup Files"
      def backup_files
        st="      "
        inside("config/initializes") {(File.file? "omniauth.rb") ? (mv omniauth.rb omniauth.rb.bak) : (puts "new omniauth.rb created")}
        inside("config/initializes") {(File.file? "mongoid.rb") ? (mv mongoid.rb omniauth.rb.bak) : (puts "new mongoid.rb created")}
        inside("config/initializes") {(File.file? "ckeditor.rb") ? (mv ckeditor.rb ckeditor.rb.bak) : (puts "new ckeditor.rb created")}
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
end
}
        end
      end
# gem 'ckeditor', github: 'galetahub/ckeditor'      
# rails generate ckeditor:install --orm=mongoid --backend=paperclip
      desc "Set up setup_ckeditor config"
      def setup_ckeditor
        initializer "ckeditor.rb" do
%q{# gem 'ckeditor', github: 'galetahub/ckeditor'      
Ckeditor.setup do |config|
  require 'ckeditor/orm/mongoid'
end  
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
        puts "      configured setup_ckeditor.\n"
        puts "      configured Mongoid.\n"
        puts "\n"
        puts "Next: To set up user/password as admin/secret\n"
        puts "Please run the following command:\n"
        puts "----------------------------------------\n"
        puts "rake jinda:seed\n"
        puts "----------------------------------------\n"
      end
    end
  end
end

