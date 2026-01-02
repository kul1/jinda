# frozen_string_literal: true

module Jinda
  module Generators
    class RspecGenerator < Rails::Generators::Base
      def self.source_root
        "#{File.dirname(__FILE__)}/templates"
      end

      desc 'config rspec'
      def gen_rspec
        # generate "rspec:install"
        # empty_directory "spec/support"
        # empty_directory "spec/model"
        # empty_directory "spec/routing"
        # copy_file ".rspec", ".rspec.bak"
        run 'guard init'
        copy_file 'dotrspec', '.rspec'
      end

      desc 'Finish generate rspec:install'
      def finish
        Rails.logger.debug "      Finish generate rspec:install.\n"
        Rails.logger.debug "      To start guard run:\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug "guard \n"
        Rails.logger.debug "-----------------------------------------\n"
      end
    end
  end
end
