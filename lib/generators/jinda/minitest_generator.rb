# frozen_string_literal: true

module Jinda
  module Generators
    class MinitestGenerator < Rails::Generators::Base
      def self.source_root
        "#{File.dirname(__FILE__)}/templates"
      end

      desc 'config minitest'
      def gen_minitest
        # copy test directory with jinda test for minitest
        directory 'test'
        run 'guard init minitest'
      end

      desc 'Finish guard init minitest'
      def finish
        Rails.logger.debug "      Finish guard init minitest.\n"
        Rails.logger.debug "      Finish copy test directory for minitest\n"
        Rails.logger.debug "      Finish copy jinda test for minitest\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug "      Please remove spec directory if exist\n"
        Rails.logger.debug "      To start guard run:\n"
        Rails.logger.debug "-----------------------------------------\n"
        Rails.logger.debug "guard \n"
        Rails.logger.debug "-----------------------------------------\n"
      end
    end
  end
end
