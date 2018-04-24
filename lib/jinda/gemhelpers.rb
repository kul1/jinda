module Jinda	
  module GemHelpers
	  require 'jinda/helpers'
		include Jinda::Helpers
			def controller_exists?(modul)
				File.exists? "~/mygem/jinda/lib/generators/jinda/templates/app/controllers/#{modul}_controller.rb"
				end
			#
			# Mock generate controller for test
			# Otherwise test will call rails g controller
			#
			def process_controllers
				process_services
				modules= Jinda::Module.all
				modules.each do |m|
					next if controller_exists?(m.code)
					puts "    Rails generate controller #{m.code}"
				end
			end

			def gen_views
				t = ["*** generate ui ***"]
			end
	end
end
	
