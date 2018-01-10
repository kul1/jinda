module Jinda
  module Generators
    class MinitestGenerator < Rails::Generators::Base
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end

      desc "config minitest"
      def gen_minitest
        #copy test directory with jinda test for minitest
        directory "test"
        run "guard init minitest"
      end

      desc "Finish guard init minitest"
      def finish 
        puts "      Finish guard init minitest.\n"
        puts "      Finish copy test directory for minitest\n"
        puts "      Finish copy jinda test for minitest\n"
        puts "-----------------------------------------\n"
        puts "      Please remove spec directory if exist\n"
        puts "      To start guard run:\n"
        puts "-----------------------------------------\n"
        puts "guard \n"
        puts "-----------------------------------------\n"
      end      
    end
  end
end

